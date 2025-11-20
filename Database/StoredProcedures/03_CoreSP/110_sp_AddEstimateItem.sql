/*******************************************************
  110_sp_AddEstimateItem — Enterprise (TVP based)
  - Uses a Table-Valued Parameter type: EstimateItemType
  - Bulk inserts multiple estimate items (labour / parts / painting)
  - Auto-creates Estimate (if @EstimateID IS NULL or 0)
  - Enforces strict branch separation (A1.1) unless @IsAdmin = 1
  - Calculates LineTotal, DiscountedTotal, GSTAmount, FinalAmount per row
  - Updates Estimate totals after insert
  - Inserts EstimateHistory
  - Notification hook: sp_NotifyEstimateChanged (if exists)
  - Author: ChatGPT (adapt names to your schema if necessary)
*******************************************************/

-- 1) Create TVP type if not exists
IF TYPE_ID(N'dbo.EstimateItemType') IS NULL
BEGIN
    CREATE TYPE dbo.EstimateItemType AS TABLE
    (
        ServiceType    VARCHAR(20),   -- 'Labour' or 'Part' or 'Painting'
        ItemName       VARCHAR(200),
        ItemCode       VARCHAR(100),
        Qty            DECIMAL(10,2),
        UnitPrice      DECIMAL(18,2),
        DiscountAmount DECIMAL(18,2) DEFAULT 0.00,
        GSTPercent     DECIMAL(5,2)  DEFAULT 0.00,
        IsFullBody     BIT           DEFAULT 0,
        PanelName      VARCHAR(100)  NULL,
        Notes          VARCHAR(MAX)  NULL,
        -- Optional: map to product id if needed
        ProductID      INT           NULL
    );
END
GO

-- 2) Stored procedure: sp_AddEstimateItem (TVP)
IF OBJECT_ID('dbo.110_sp_AddEstimateItem', 'P') IS NOT NULL
    DROP PROCEDURE dbo.110_sp_AddEstimateItem;
GO

CREATE PROCEDURE dbo.110_sp_AddEstimateItem
    @PerformedByUserID    INT,
    @IsAdmin              BIT = 0,
    @EstimateID           INT = NULL,   -- if NULL or 0 => create new estimate
    @JobID                INT = NULL,   -- optional link to job
    @BranchID             INT = NULL,   -- preferred Branch; will be resolved
    @EstimateRemarks      VARCHAR(MAX) = NULL,
    @EstimateSource       VARCHAR(50) = 'Normal', -- 'Normal' | 'Insurance' | 'Priority'
    @Items                dbo.EstimateItemType READONLY,
    -- OUTPUT
    @OutEstimateID        INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
        @Now DATETIME = GETDATE(),
        @UserBranchID INT,
        @EffectiveBranchID INT,
        @NewEstimateID INT,
        @ErrorMessage NVARCHAR(4000);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Basic validations
        IF @PerformedByUserID IS NULL
            RAISERROR('PerformedByUserID is required',16,1);

        -- resolve user branch
        SELECT @UserBranchID = BranchID FROM dbo.Users WHERE UserID = @PerformedByUserID;
        IF @UserBranchID IS NULL
            RAISERROR('Invalid PerformedByUserID or user has no Branch assigned.',16,1);

        -- Determine effective branch: prefer passed @BranchID -> Job's branch -> user's branch
        SET @EffectiveBranchID = @BranchID;

        IF @EffectiveBranchID IS NULL AND @JobID IS NOT NULL
        BEGIN
            SELECT @EffectiveBranchID = BranchID FROM dbo.Jobs WHERE JobID = @JobID;
        END

        IF @EffectiveBranchID IS NULL
            SET @EffectiveBranchID = @UserBranchID;

        -- Strict branch separation
        IF (@IsAdmin = 0) AND (@UserBranchID <> @EffectiveBranchID)
            RAISERROR('Branch mismatch: user not allowed to create/update estimate for this branch.',16,1);

        /* ----------------------------
           Create Estimate header if not provided
           ---------------------------- */
        IF @EstimateID IS NULL OR @EstimateID = 0
        BEGIN
            -- Ensure Estimates table exists (fallback minimal)
            IF OBJECT_ID('dbo.Estimates','U') IS NULL
            BEGIN
                CREATE TABLE dbo.Estimates (
                    EstimateID INT IDENTITY(1,1) PRIMARY KEY,
                    JobID INT NULL,
                    BranchID INT NULL,
                    EstimateDate DATETIME,
                    CreatedBy INT,
                    CreatedDate DATETIME,
                    Remarks VARCHAR(MAX),
                    EstimateSource VARCHAR(50),
                    SubTotal DECIMAL(18,2) DEFAULT 0.00,
                    TotalDiscount DECIMAL(18,2) DEFAULT 0.00,
                    TotalGST DECIMAL(18,2) DEFAULT 0.00,
                    GrandTotal DECIMAL(18,2) DEFAULT 0.00
                );
            END

            INSERT INTO dbo.Estimates
                (JobID, BranchID, EstimateDate, CreatedBy, CreatedDate, Remarks, EstimateSource, SubTotal, TotalDiscount, TotalGST, GrandTotal)
            VALUES
                (@JobID, @EffectiveBranchID, @Now, @PerformedByUserID, @Now, @EstimateRemarks, @EstimateSource, 0.00, 0.00, 0.00, 0.00);

            SET @NewEstimateID = CAST(SCOPE_IDENTITY() AS INT);
        END
        ELSE
        BEGIN
            -- validate estimate exists and belongs to branch (unless admin)
            IF NOT EXISTS (SELECT 1 FROM dbo.Estimates WHERE EstimateID = @EstimateID)
                RAISERROR('EstimateID not found: %d',16,1,@EstimateID);

            SET @NewEstimateID = @EstimateID;

            -- validate branch
            IF @IsAdmin = 0
            BEGIN
                DECLARE @EstimateBranch INT;
                SELECT @EstimateBranch = BranchID FROM dbo.Estimates WHERE EstimateID = @NewEstimateID;
                IF @EstimateBranch IS NOT NULL AND @EstimateBranch <> @EffectiveBranchID
                BEGIN
                    RAISERROR('Estimate belongs to different branch. Use admin to override.',16,1);
                END
            END
        END

        /* ----------------------------
           Ensure EstimateItems table exists (fallback minimal)
        ---------------------------- */
        IF OBJECT_ID('dbo.EstimateItems','U') IS NULL
        BEGIN
            CREATE TABLE dbo.EstimateItems (
                EstimateItemID INT IDENTITY(1,1) PRIMARY KEY,
                EstimateID INT NOT NULL,
                JobID INT NULL,
                BranchID INT NULL,
                ServiceType VARCHAR(20),
                ItemName VARCHAR(200),
                ItemCode VARCHAR(100),
                Qty DECIMAL(10,2),
                UnitPrice DECIMAL(18,2),
                LineTotal DECIMAL(18,2),
                DiscountAmount DECIMAL(18,2),
                DiscountedTotal DECIMAL(18,2),
                GSTPercent DECIMAL(5,2),
                GSTAmount DECIMAL(18,2),
                FinalAmount DECIMAL(18,2),
                IsFullBody BIT,
                PanelName VARCHAR(100),
                ProductID INT NULL,
                Notes VARCHAR(MAX),
                CreatedBy INT,
                CreatedDate DATETIME
            );
        END

        /* ----------------------------
           Bulk insert rows from TVP with calculations
           ---------------------------- */
        ;WITH ItemsCalc AS (
            SELECT
                ISNULL(ServiceType,'Part')             AS ServiceType,
                ISNULL(ItemName,'')                    AS ItemName,
                ISNULL(ItemCode,'')                    AS ItemCode,
                ISNULL(Qty,0)                          AS Qty,
                ISNULL(UnitPrice,0.00)                 AS UnitPrice,
                ISNULL(DiscountAmount,0.00)            AS DiscountAmount,
                ISNULL(GSTPercent,0.00)                AS GSTPercent,
                ISNULL(IsFullBody,0)                   AS IsFullBody,
                ISNULL(PanelName,NULL)                 AS PanelName,
                ISNULL(ProductID,NULL)                 AS ProductID,
                ISNULL(Notes,NULL)                     AS Notes,
                -- Calculations (digit-by-digit style):
                -- LineTotal = Qty * UnitPrice
                (ISNULL(Qty,0) * ISNULL(UnitPrice,0.00)) AS LineTotal,
                -- DiscountedTotal = LineTotal - DiscountAmount
                ((ISNULL(Qty,0) * ISNULL(UnitPrice,0.00)) - ISNULL(DiscountAmount,0.00)) AS DiscountedTotal,
                -- GSTAmount = DiscountedTotal * (GSTPercent / 100)
                ( ((ISNULL(Qty,0) * ISNULL(UnitPrice,0.00)) - ISNULL(DiscountAmount,0.00)) * (ISNULL(GSTPercent,0.00) / 100.0) ) AS GSTAmount,
                -- FinalAmount = DiscountedTotal + GSTAmount
                ( ((ISNULL(Qty,0) * ISNULL(UnitPrice,0.00)) - ISNULL(DiscountAmount,0.00)) + 
                  ( ((ISNULL(Qty,0) * ISNULL(UnitPrice,0.00)) - ISNULL(DiscountAmount,0.00)) * (ISNULL(GSTPercent,0.00)/100.0) ) ) AS FinalAmount
            FROM @Items
        )
        INSERT INTO dbo.EstimateItems
            (EstimateID, JobID, BranchID, ServiceType, ItemName, ItemCode, Qty, UnitPrice, LineTotal, DiscountAmount, DiscountedTotal, GSTPercent, GSTAmount, FinalAmount, IsFullBody, PanelName, ProductID, Notes, CreatedBy, CreatedDate)
        SELECT
            @NewEstimateID, @JobID, @EffectiveBranchID,
            ServiceType, ItemName, ItemCode, Qty, UnitPrice, LineTotal, DiscountAmount, DiscountedTotal, GSTPercent, GSTAmount, FinalAmount, IsFullBody, PanelName, ProductID, Notes, @PerformedByUserID, @Now
        FROM ItemsCalc;

        /* ----------------------------
           Update Estimate totals (recalculate from EstimateItems)
        ---------------------------- */
        DECLARE @SubTotal DECIMAL(18,2), @TotalDiscount DECIMAL(18,2), @TotalGST DECIMAL(18,2), @GrandTotal DECIMAL(18,2);

        SELECT
            @SubTotal = ISNULL(SUM(LineTotal),0.00),
            @TotalDiscount = ISNULL(SUM(DiscountAmount),0.00),
            @TotalGST = ISNULL(SUM(GSTAmount),0.00),
            @GrandTotal = ISNULL(SUM(FinalAmount),0.00)
        FROM dbo.EstimateItems
        WHERE EstimateID = @NewEstimateID;

        UPDATE dbo.Estimates
        SET SubTotal = @SubTotal,
            TotalDiscount = @TotalDiscount,
            TotalGST = @TotalGST,
            GrandTotal = @GrandTotal,
            Remarks = CASE WHEN ISNULL(@EstimateRemarks,'') = '' THEN Remarks ELSE CONCAT(ISNULL(Remarks,''), CHAR(13)+CHAR(10), '[ItemsAdded - ', CONVERT(VARCHAR(19), @Now, 120), '] ', @EstimateRemarks) END
        WHERE EstimateID = @NewEstimateID;

        /* ----------------------------
           Insert Estimate History
        ---------------------------- */
        IF OBJECT_ID('dbo.EstimateHistory','U') IS NULL
        BEGIN
            CREATE TABLE dbo.EstimateHistory (
                EstimateHistoryID INT IDENTITY(1,1) PRIMARY KEY,
                EstimateID INT NOT NULL,
                EventType VARCHAR(50),
                Notes VARCHAR(MAX),
                ChangedBy INT,
                ChangedDate DATETIME,
                BranchID INT NULL
            );
        END

        INSERT INTO dbo.EstimateHistory (EstimateID, EventType, Notes, ChangedBy, ChangedDate, BranchID)
        VALUES (@NewEstimateID, 'ItemsAdded', CONCAT('Added ', (SELECT COUNT(1) FROM @Items), ' items. Total: ', CONVERT(VARCHAR(32), @GrandTotal)), @PerformedByUserID, @Now, @EffectiveBranchID);

        /* ----------------------------
           Optional: Inventory reservations / stock checks (NOT done here in Phase-1)
           Phase-1 policy: we keep stock logic separate; this SP only writes estimate items.
        ---------------------------- */

        /* ----------------------------
           Notification hook
        ---------------------------- */
        IF OBJECT_ID('dbo.sp_NotifyEstimateChanged','P') IS NOT NULL
        BEGIN
            EXEC dbo.sp_NotifyEstimateChanged @EstimateID = @NewEstimateID, @ChangedBy = @PerformedByUserID;
        END

        COMMIT TRANSACTION;

        SET @OutEstimateID = @NewEstimateID;
        SELECT @OutEstimateID AS EstimateID, @SubTotal AS SubTotal, @TotalDiscount AS TotalDiscount, @TotalGST AS TotalGST, @GrandTotal AS GrandTotal;
        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrNo INT = ERROR_NUMBER(), @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = CONCAT('Error(', @ErrNo, '): ', @ErrMsg);
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN @ErrNo;
    END CATCH
END
GO
