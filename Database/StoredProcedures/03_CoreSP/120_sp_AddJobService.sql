/*************************************************************
   120_sp_AddJobService — Enterprise Version (Phase-1)
   - Adds services/labour/parts to an existing Job Card
   - Enforces strict branch separation (A1.1)
   - Supports Full Body Painting + panel auto-insert
   - Updates JobServices table
   - Updates EstimateItems (optional)
   - No MRF logic (Phase-1)
   - Inserts service history
*************************************************************/

IF OBJECT_ID('dbo.120_sp_AddJobService', 'P') IS NOT NULL
    DROP PROCEDURE dbo.120_sp_AddJobService;
GO

CREATE PROCEDURE dbo.120_sp_AddJobService
(
    @PerformedByUserID     INT,
    @IsAdmin               BIT = 0,
    @JobID                 INT,
    @BranchID              INT = NULL,
    @ServiceCode           VARCHAR(100),
    @ServiceName           VARCHAR(200),
    @Qty                   DECIMAL(10,2) = 1,
    @UnitPrice             DECIMAL(18,2) = 0.00,
    @IsPackage             BIT = 0,
    @IsFullBody            BIT = 0,
    @VehicleCategory       VARCHAR(20) = NULL,
    @AddToEstimate         BIT = 1,
    @Notes                 VARCHAR(MAX) = NULL,
    -- OUTPUT
    @OutJobServiceID       INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE 
        @Now DATETIME = GETDATE(),
        @JobBranchID INT,
        @UserBranchID INT,
        @JobServiceID INT,
        @EstimateID INT,
        @ErrorMessage NVARCHAR(4000);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* ---------------------------------------------
            Validate job exists + load branch
        -----------------------------------------------*/
        SELECT @JobBranchID = BranchID FROM dbo.Jobs WHERE JobID = @JobID;

        IF @JobBranchID IS NULL
            RAISERROR('JobID %d not found.',16,1,@JobID);

        /* ---------------------------------------------
            Get User branch
        -----------------------------------------------*/
        SELECT @UserBranchID = BranchID 
        FROM dbo.Users 
        WHERE UserID = @PerformedByUserID;

        IF @UserBranchID IS NULL
            RAISERROR('Invalid PerformedByUserID.',16,1);

        /* ---------------------------------------------
            Strict Branch Separation (A1.1)
        -----------------------------------------------*/
        IF (@IsAdmin = 0 AND @UserBranchID <> @JobBranchID)
            RAISERROR('Branch mismatch. User cannot add service to this job.',16,1);

        /* ---------------------------------------------
            Insert into JobServices
        -----------------------------------------------*/
        INSERT INTO dbo.JobServices
        (
            JobID, BranchID, ServiceCode, ServiceName,
            Qty, UnitPrice, TotalPrice,
            IsPackage, IsFullBody, VehicleCategory,
            Notes,
            CreatedBy, CreatedDate
        )
        VALUES
        (
            @JobID, @JobBranchID, @ServiceCode, @ServiceName,
            @Qty, @UnitPrice, (@Qty * @UnitPrice),
            @IsPackage, @IsFullBody, @VehicleCategory,
            @Notes,
            @PerformedByUserID, @Now
        );

        SET @JobServiceID = SCOPE_IDENTITY();

        /* ---------------------------------------------
            Auto-insert full-body panels
        -----------------------------------------------*/
        IF @IsFullBody = 1
        BEGIN
            -- Ensure tables exist
            IF OBJECT_ID('dbo.PaintingPanelsMaster','U') IS NOT NULL
               AND OBJECT_ID('dbo.JobServicePanels','U') IS NOT NULL
            BEGIN
                INSERT INTO dbo.JobServicePanels
                (
                    JobID, ServiceCode, PanelName, PanelSequence,
                    CreatedBy, CreatedDate
                )
                SELECT
                    @JobID,
                    @ServiceCode,
                    ppm.PanelName,
                    ppm.PanelSequence,
                    @PerformedByUserID,
                    @Now
                FROM dbo.PaintingPanelsMaster ppm
                WHERE ppm.IsActive = 1;
            END
        END

        /* ---------------------------------------------
            Auto-add service to Estimate
        -----------------------------------------------*/
        IF @AddToEstimate = 1
        BEGIN
            -- find estimate for job
            SELECT @EstimateID = EstimateID
            FROM dbo.Estimates
            WHERE JobID = @JobID;

            -- create estimate automatically if not exists
            IF @EstimateID IS NULL
            BEGIN
                INSERT INTO dbo.Estimates
                (
                    JobID, BranchID, EstimateDate, CreatedBy,
                    CreatedDate, Remarks, EstimateSource
                )
                VALUES
                (
                    @JobID, @JobBranchID, @Now, @PerformedByUserID,
                    @Now, 'Auto Created (Service Added)', 'Normal'
                );

                SET @EstimateID = SCOPE_IDENTITY();
            END

            -- insert estimate item
            INSERT INTO dbo.EstimateItems
            (
                EstimateID, JobID, BranchID, ServiceType,
                ItemName, ItemCode, Qty, UnitPrice,
                LineTotal, DiscountAmount, DiscountedTotal,
                GSTPercent, GSTAmount, FinalAmount,
                IsFullBody, CreatedBy, CreatedDate
            )
            VALUES
            (
                @EstimateID, @JobID, @JobBranchID, 'Labour',
                @ServiceName, @ServiceCode, @Qty, @UnitPrice,
                (@Qty * @UnitPrice), 0, (@Qty * @UnitPrice),
                0, 0, (@Qty * @UnitPrice),
                @IsFullBody, @PerformedByUserID, @Now
            );
        END

        /* ---------------------------------------------
            Insert service history (optional)
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.JobServiceHistory','U') IS NOT NULL
        BEGIN
            INSERT INTO dbo.JobServiceHistory
            (
                JobID, JobServiceID, EventType, Notes,
                ChangedBy, ChangedDate
            )
            VALUES
            (
                @JobID, @JobServiceID, 'ServiceAdded',
                @Notes, @PerformedByUserID, @Now
            );
        END

        /* ---------------------------------------------
            Notification Hook
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.sp_NotifyNewJobService','P') IS NOT NULL
        BEGIN
            EXEC dbo.sp_NotifyNewJobService @JobID = @JobID, @JobServiceID = @JobServiceID;
        END

        COMMIT TRANSACTION;

        SET @OutJobServiceID = @JobServiceID;
        SELECT @OutJobServiceID AS JobServiceID;

        RETURN 0;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        DECLARE @ErrNo INT = ERROR_NUMBER(),
                @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

        RAISERROR('Error(%d): %s',16,1,@ErrNo,@ErrMsg);
        RETURN @ErrNo;
    END CATCH
END
GO
