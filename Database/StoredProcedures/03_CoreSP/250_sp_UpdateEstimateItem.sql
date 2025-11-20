/*************************************************************
   140_sp_UpdateEstimateItem — Enterprise (Phase-1)
   - Updates a single estimate item
   - Recalculates Estimate totals after update
   - Enforces strict branch separation (A1.1)
   - Supports labour, parts, painting, full-body options
   - Supports panel updates
*************************************************************/

IF OBJECT_ID('dbo.140_sp_UpdateEstimateItem', 'P') IS NOT NULL
    DROP PROCEDURE dbo.140_sp_UpdateEstimateItem;
GO

CREATE PROCEDURE dbo.140_sp_UpdateEstimateItem
(
    @PerformedByUserID     INT,
    @IsAdmin               BIT = 0,
    @EstimateItemID        INT,
    @Qty                   DECIMAL(10,2) = NULL,
    @UnitPrice             DECIMAL(18,2) = NULL,
    @DiscountAmount        DECIMAL(18,2) = NULL,
    @GSTPercent            DECIMAL(5,2) = NULL,
    @PanelName             VARCHAR(100) = NULL,
    @Notes                 VARCHAR(MAX) = NULL,
    -- OUTPUT
    @OutUpdated            BIT OUTPUT
)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE 
        @Now DATETIME = GETDATE(),
        @EstimateID INT,
        @JobID INT,
        @BranchID INT,
        @UserBranchID INT,
        @LineTotal DECIMAL(18,2),
        @DiscountedTotal DECIMAL(18,2),
        @GSTAmount DECIMAL(18,2),
        @FinalAmount DECIMAL(18,2);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* ---------------------------------------------
           Validate Estimate Item exists
        -----------------------------------------------*/
        SELECT 
            @EstimateID = EstimateID,
            @JobID = JobID,
            @BranchID = BranchID
        FROM dbo.EstimateItems
        WHERE EstimateItemID = @EstimateItemID;

        IF @EstimateID IS NULL
            RAISERROR('EstimateItemID %d not found.',16,1,@EstimateItemID);

        /* ---------------------------------------------
            Validate User Branch
        -----------------------------------------------*/
        SELECT @UserBranchID = BranchID 
        FROM dbo.Users
        WHERE UserID = @PerformedByUserID;

        IF @UserBranchID IS NULL
            RAISERROR('Invalid PerformedByUserID.',16,1);

        /* ---------------------------------------------
           Strict Branch Separation (A1.1)
        -----------------------------------------------*/
        IF @IsAdmin = 0 AND @UserBranchID <> @BranchID
            RAISERROR('Branch mismatch. User cannot update Estimate Item in this branch.',16,1);

        /* ---------------------------------------------
           Get existing values to compute new totals
        -----------------------------------------------*/
        DECLARE 
            @OldQty DECIMAL(18,2),
            @OldUnitPrice DECIMAL(18,2),
            @OldDiscount DECIMAL(18,2),
            @OldGST DECIMAL(18,2);

        SELECT 
            @OldQty = Qty,
            @OldUnitPrice = UnitPrice,
            @OldDiscount = DiscountAmount,
            @OldGST = GSTPercent
        FROM dbo.EstimateItems
        WHERE EstimateItemID = @EstimateItemID;

        /* Apply new values only if provided */
        SET @Qty = COALESCE(@Qty, @OldQty);
        SET @UnitPrice = COALESCE(@UnitPrice, @OldUnitPrice);
        SET @DiscountAmount = COALESCE(@DiscountAmount, @OldDiscount);
        SET @GSTPercent = COALESCE(@GSTPercent, @OldGST);

        /* ---------------------------------------------
           Recalculate totals
        -----------------------------------------------*/
        SET @LineTotal = (@Qty * @UnitPrice);
        SET @DiscountedTotal = (@LineTotal - @DiscountAmount);
        SET @GSTAmount = (@DiscountedTotal * (@GSTPercent / 100.0));
        SET @FinalAmount = (@DiscountedTotal + @GSTAmount);

        /* ---------------------------------------------
           Update Estimate Item
        -----------------------------------------------*/
        UPDATE dbo.EstimateItems
        SET 
            Qty = @Qty,
            UnitPrice = @UnitPrice,
            DiscountAmount = @DiscountAmount,
            DiscountedTotal = @DiscountedTotal,
            LineTotal = @LineTotal,
            GSTPercent = @GSTPercent,
            GSTAmount = @GSTAmount,
            FinalAmount = @FinalAmount,
            PanelName = COALESCE(@PanelName, PanelName),
            Notes = CASE WHEN @Notes IS NULL THEN Notes 
                         ELSE CONCAT(ISNULL(Notes,''), CHAR(13)+CHAR(10),'[Update] ',@Notes) END,
            ModifiedBy = @PerformedByUserID,
            ModifiedDate = @Now
        WHERE EstimateItemID = @EstimateItemID;

        /* ---------------------------------------------
           Recalculate Estimate main totals
        -----------------------------------------------*/
        DECLARE 
            @SubTotal DECIMAL(18,2),
            @TotalDiscount DECIMAL(18,2),
            @TotalGST DECIMAL(18,2),
            @GrandTotal DECIMAL(18,2);

        SELECT
            @SubTotal = SUM(LineTotal),
            @TotalDiscount = SUM(DiscountAmount),
            @TotalGST = SUM(GSTAmount),
            @GrandTotal = SUM(FinalAmount)
        FROM dbo.EstimateItems
        WHERE EstimateID = @EstimateID;

        UPDATE dbo.Estimates
        SET SubTotal = @SubTotal,
            TotalDiscount = @TotalDiscount,
            TotalGST = @TotalGST,
            GrandTotal = @GrandTotal
        WHERE EstimateID = @EstimateID;

        /* ---------------------------------------------
           Add EstimateHistory
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.EstimateHistory','U') IS NOT NULL
        BEGIN
            INSERT INTO dbo.EstimateHistory
            (
                EstimateID, EventType, Notes,
                ChangedBy, ChangedDate, BranchID
            )
            VALUES
            (
                @EstimateID, 'ItemUpdated',
                CONCAT('EstimateItemID: ',@EstimateItemID),
                @PerformedByUserID, @Now, @BranchID
            );
        END

        SET @OutUpdated = 1;

        COMMIT TRANSACTION;

        SELECT @OutUpdated AS Updated, @EstimateItemID AS EstimateItemID;

        RETURN 0;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        SET @OutUpdated = 0;

        DECLARE @ErrNo INT = ERROR_NUMBER(),
                @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

        RAISERROR('Error(%d): %s',16,1,@ErrNo,@ErrMsg);
        RETURN @ErrNo;
    END CATCH
END
GO
