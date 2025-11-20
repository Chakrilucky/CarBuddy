/*************************************************************
   130_sp_DeleteJobService — Enterprise Version (Phase-1)
   - Safely deletes a service from Job Card
   - Enforces strict branch separation (A1.1)
   - If service is FULL BODY → delete panels also
   - Removes linked Estimate Items
   - Adds JobServiceHistory record
   - Phase-1: No MRF logic
*************************************************************/

IF OBJECT_ID('dbo.130_sp_DeleteJobService', 'P') IS NOT NULL
    DROP PROCEDURE dbo.130_sp_DeleteJobService;
GO

CREATE PROCEDURE dbo.130_sp_DeleteJobService
(
    @PerformedByUserID     INT,
    @IsAdmin               BIT = 0,
    @JobServiceID          INT,
    @Reason                VARCHAR(MAX) = NULL,
    -- Output
    @OutDeleted            BIT OUTPUT
)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
        @Now DATETIME = GETDATE(),
        @JobID INT,
        @JobBranchID INT,
        @UserBranchID INT,
        @ServiceCode VARCHAR(100),
        @IsFullBody BIT,
        @ErrorMessage NVARCHAR(4000);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* ---------------------------------------------
            Validate service row exists
        -----------------------------------------------*/
        SELECT TOP 1
            @JobID = JobID,
            @JobBranchID = BranchID,
            @ServiceCode = ServiceCode,
            @IsFullBody = IsFullBody
        FROM dbo.JobServices
        WHERE JobServiceID = @JobServiceID;

        IF @JobID IS NULL
            RAISERROR('JobServiceID %d not found.', 16, 1, @JobServiceID);

        /* ---------------------------------------------
            Get user branch
        -----------------------------------------------*/
        SELECT @UserBranchID = BranchID
        FROM dbo.Users
        WHERE UserID = @PerformedByUserID;

        IF @UserBranchID IS NULL
            RAISERROR('Invalid PerformedByUserID.', 16, 1);

        /* ---------------------------------------------
            Strict Branch Separation (A1.1)
        -----------------------------------------------*/
        IF (@IsAdmin = 0 AND @UserBranchID <> @JobBranchID)
            RAISERROR('Branch mismatch. User cannot delete service for this job.',16,1);

        /* ---------------------------------------------
            If this is Full Body Painting → remove panels
        -----------------------------------------------*/
        IF @IsFullBody = 1
        BEGIN
            IF OBJECT_ID('dbo.JobServicePanels','U') IS NOT NULL
            BEGIN
                DELETE FROM dbo.JobServicePanels
                WHERE JobID = @JobID
                  AND ServiceCode = @ServiceCode;
            END
        END

        /* ---------------------------------------------
            Remove from EstimateItems (if exists)
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.EstimateItems','U') IS NOT NULL
        BEGIN
            DELETE FROM dbo.EstimateItems
            WHERE JobID = @JobID
              AND ItemCode = @ServiceCode;
        END

        /* ---------------------------------------------
            Delete Job Service
        -----------------------------------------------*/
        DELETE FROM dbo.JobServices
        WHERE JobServiceID = @JobServiceID;

        SET @OutDeleted = 1;

        /* ---------------------------------------------
            Insert History
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.JobServiceHistory','U') IS NOT NULL
        BEGIN
            INSERT INTO dbo.JobServiceHistory
            (
                JobID, JobServiceID, EventType,
                Notes, ChangedBy, ChangedDate
            )
            VALUES
            (
                @JobID, @JobServiceID, 'ServiceDeleted',
                @Reason, @PerformedByUserID, @Now
            );
        END

        /* ---------------------------------------------
            Notification Hook
        -----------------------------------------------*/
        IF OBJECT_ID('dbo.sp_NotifyJobServiceDeleted','P') IS NOT NULL
        BEGIN
            EXEC dbo.sp_NotifyJobServiceDeleted 
                 @JobID = @JobID,
                 @JobServiceID = @JobServiceID;
        END

        COMMIT TRANSACTION;

        SELECT @OutDeleted AS Deleted, @JobServiceID AS JobServiceID;

        RETURN 0;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        DECLARE @ErrNo INT = ERROR_NUMBER(),
                @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

        SET @OutDeleted = 0;

        RAISERROR('Error(%d): %s',16,1,@ErrNo,@ErrMsg);
        RETURN @ErrNo;
    END CATCH;
END
GO
