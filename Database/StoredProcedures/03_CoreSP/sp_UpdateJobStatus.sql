/*******************************************************
  sp_UpdateJobStatus — Enterprise (Phase-1)
  - Enforces strict branch separation (unless @IsAdmin = 1)
  - Updates Jobs.JobStatus and related fields
  - Records JobStatusHistory
  - Handles Priority behaviors (Premium)
  - Handles Insurance claim status transitions
  - Handles Full Body Painting panel QC status promotion
  - Notification hook: dbo.sp_NotifyJobStatusChanged (if exists)
  - Author: ChatGPT (adapt names to your schema if necessary)
*******************************************************/

IF OBJECT_ID('dbo.sp_UpdateJobStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdateJobStatus;
GO

CREATE PROCEDURE dbo.sp_UpdateJobStatus
    @PerformedByUserID     INT,
    @IsAdmin               BIT = 0,            -- Admin can override branch checks
    @JobID                 INT,
    @NewStatus             VARCHAR(50),        -- e.g., 'InProgress','QC','Completed','Closed','OnHold','Cancelled'
    @StatusRemarks         VARCHAR(MAX) = NULL,
    @StatusDate            DATETIME = NULL,    -- if null -> GETDATE()
    -- Optional: set delivery / completion dates explicitly
    @ActualDeliveryDate    DATETIME = NULL,
    @ActualCompletionDate  DATETIME = NULL,
    -- Insurance specific (optional)
    @InsuranceStatus       VARCHAR(50) = NULL, -- e.g., 'SurveyorRequested','Surveyed','Approved','Rejected','PaymentDone'
    @InsuranceNotes        VARCHAR(MAX) = NULL,
    -- Optional: reassign technician or set stage
    @AssignedTechnicianID  INT = NULL,
    @JobStage              VARCHAR(50) = NULL, -- e.g., 'Denting','Painting','Washing','QA'
    -- Output
    @OutJobID              INT OUTPUT,
    @OutOldStatus          VARCHAR(50) OUTPUT,
    @OutNewStatus          VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
        @Now DATETIME = ISNULL(@StatusDate, GETDATE()),
        @JobBranchID INT,
        @UserBranchID INT,
        @OldStatus VARCHAR(50),
        @ErrorMessage NVARCHAR(4000);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* ----------------------------
           Basic validations
        ---------------------------- */
        IF @JobID IS NULL OR @JobID <= 0
            RAISERROR('JobID is required.', 16, 1);

        IF ISNULL(LTRIM(RTRIM(@NewStatus)), '') = ''
            RAISERROR('NewStatus is required.', 16, 1);

        SELECT @UserBranchID = BranchID FROM dbo.Users WHERE UserID = @PerformedByUserID;
        IF @UserBranchID IS NULL
            RAISERROR('Invalid PerformedByUserID or user has no Branch assigned.', 16, 1);

        SELECT 
            @JobBranchID = BranchID,
            @OldStatus = JobStatus
        FROM dbo.Jobs WITH (NOLOCK)
        WHERE JobID = @JobID;

        IF @JobBranchID IS NULL
            RAISERROR('Job not found: %d', 16, 1, @JobID);

        -- Strict branch separation: user can update job only for same branch unless admin
        IF (@IsAdmin = 0) AND (@UserBranchID <> @JobBranchID)
            RAISERROR('Branch mismatch: user is not allowed to update this job.', 16, 1);

        /* ----------------------------
           Business rules and allowed transitions
           (You can customise allowed transitions list as per business)
        ---------------------------- */
        -- Example simple validation: don't move from Closed back to Open unless admin
        IF @OldStatus IN ('Closed','Cancelled') AND @IsAdmin = 0
        BEGIN
            RAISERROR('Cannot change status of a Closed or Cancelled job.',16,1);
        END

        /* ----------------------------
           1) Update Jobs table main fields
        ---------------------------- */
        UPDATE dbo.Jobs
        SET
            JobStatus = @NewStatus,
            LastStatusUpdatedBy = @PerformedByUserID,
            LastStatusUpdatedDate = @Now,
            ActualDeliveryDate = COALESCE(@ActualDeliveryDate, ActualDeliveryDate),
            ActualCompletionDate = COALESCE(@ActualCompletionDate, ActualCompletionDate),
            AssignedTechnicianID = COALESCE(@AssignedTechnicianID, AssignedTechnicianID),
            CurrentStage = COALESCE(@JobStage, CurrentStage),
            Remarks = CASE WHEN ISNULL(@StatusRemarks,'') = '' THEN Remarks ELSE CONCAT(ISNULL(Remarks,''), CHAR(13)+CHAR(10)+'[StatusUpdate - ', CONVERT(VARCHAR(19),@Now,120), '] ', @StatusRemarks) END
        WHERE JobID = @JobID;

        /* ----------------------------
           2) Write JobStatusHistory
        ---------------------------- */
        IF OBJECT_ID('dbo.JobStatusHistory','U') IS NULL
        BEGIN
            -- Minimal fallback table
            CREATE TABLE dbo.JobStatusHistory (
                JobStatusHistoryID INT IDENTITY(1,1) PRIMARY KEY,
                JobID INT NOT NULL,
                OldStatus VARCHAR(50),
                NewStatus VARCHAR(50),
                ChangedBy INT,
                ChangedDate DATETIME,
                Remarks VARCHAR(MAX),
                BranchID INT NULL
            );
        END

        INSERT INTO dbo.JobStatusHistory
            (JobID, OldStatus, NewStatus, ChangedBy, ChangedDate, Remarks, BranchID)
        VALUES
            (@JobID, @OldStatus, @NewStatus, @PerformedByUserID, @Now, @StatusRemarks, @JobBranchID);

        /* ----------------------------
           3) Priority handling (Premium)
           - If Premium and moved to InProgress, set StartedDate
           - If Premium and moved to QC or Completed store timestamps / escalate
        ---------------------------- */
        IF EXISTS (SELECT 1 FROM dbo.Jobs WHERE JobID = @JobID AND PriorityType = 'Premium')
        BEGIN
            IF @NewStatus = 'InProgress'
            BEGIN
                UPDATE dbo.Jobs SET PremiumStartedDate = COALESCE(PremiumStartedDate, @Now) WHERE JobID = @JobID;
                -- Optionally log to Alerts table or create high-priority notification
                IF OBJECT_ID('dbo.Alerts','U') IS NOT NULL
                BEGIN
                    INSERT INTO dbo.Alerts (BranchID, JobID, AlertType, Message, CreatedBy, CreatedDate)
                    VALUES (@JobBranchID, @JobID, 'Priority', 'Premium job started - expedite', @PerformedByUserID, @Now);
                END
            END

            IF @NewStatus IN ('QC','Completed')
            BEGIN
                UPDATE dbo.Jobs SET PremiumReachedQCDate = COALESCE(PremiumReachedQCDate, @Now) WHERE JobID = @JobID;
            END
        END

        /* ----------------------------
           4) Insurance workflow transitions
           - If InsuranceStatus provided, create / update InsuranceClaims status history
        ---------------------------- */
        IF ISNULL(LTRIM(RTRIM(@InsuranceStatus)),'') <> ''
        BEGIN
            -- Ensure InsuranceClaims table exists (should exist in your DB)
            IF OBJECT_ID('dbo.InsuranceClaims','U') IS NOT NULL
            BEGIN
                -- If claim exists for job, update status; otherwise create
                DECLARE @ExistingClaimID INT;
                SELECT @ExistingClaimID = InsuranceClaimID FROM dbo.InsuranceClaims WHERE JobID = @JobID;

                IF @ExistingClaimID IS NULL
                BEGIN
                    INSERT INTO dbo.InsuranceClaims
                        (JobID, BranchID, InsuranceCompanyID, PolicyNumber, ClaimReference, ClaimStatus, ClaimNotes, CreatedBy, CreatedDate)
                    VALUES
                        (@JobID, @JobBranchID, NULL, NULL, NULL, @InsuranceStatus, @InsuranceNotes, @PerformedByUserID, @Now);

                    SET @ExistingClaimID = SCOPE_IDENTITY();

                    -- Update Jobs.InsuranceClaimID if column exists
                    IF COL_LENGTH('dbo.Jobs', 'InsuranceClaimID') IS NOT NULL
                    BEGIN
                        UPDATE dbo.Jobs SET InsuranceClaimID = @ExistingClaimID WHERE JobID = @JobID;
                    END
                END
                ELSE
                BEGIN
                    -- Update existing claim status and notes
                    UPDATE dbo.InsuranceClaims
                    SET ClaimStatus = @InsuranceStatus,
                        ClaimNotes = CASE WHEN ISNULL(@InsuranceNotes,'') = '' THEN ClaimNotes ELSE CONCAT(ISNULL(ClaimNotes,''), CHAR(13)+CHAR(10), '[Update - ', CONVERT(VARCHAR(19),@Now,120), '] ', @InsuranceNotes) END,
                        ModifiedBy = @PerformedByUserID,
                        ModifiedDate = @Now
                    WHERE InsuranceClaimID = @ExistingClaimID;

                    -- Optional: write to InsuranceClaimStatusHistory if exists
                    IF OBJECT_ID('dbo.InsuranceClaimStatusHistory','U') IS NOT NULL
                    BEGIN
                        INSERT INTO dbo.InsuranceClaimStatusHistory (InsuranceClaimID, Status, Notes, ChangedBy, ChangedDate)
                        VALUES (@ExistingClaimID, @InsuranceStatus, @InsuranceNotes, @PerformedByUserID, @Now);
                    END
                END
            END
        END

        /* ----------------------------
           5) Full Body Painting workflow
           - When Job moves to 'QC', ensure JobServicePanels for FULL_BODY_PAINT are marked ready for QC
           - Optionally set PanelStatus values or record QC timestamps
        ---------------------------- */
        IF @NewStatus = 'QC'
        BEGIN
            IF OBJECT_ID('dbo.JobServicePanels','U') IS NOT NULL
            BEGIN
                -- Mark panels as ready for QC for FULL_BODY_PAINT services
                UPDATE jsp
                SET PanelStatus = CASE WHEN ISNULL(jsp.PanelStatus,'') = '' THEN 'ReadyForQC' ELSE jsp.PanelStatus END,
                    QCReadyDate = COALESCE(jsp.QCReadyDate, @Now)
                FROM dbo.JobServicePanels jsp
                INNER JOIN dbo.JobServices js ON js.JobID = jsp.JobID AND js.ServiceCode = jsp.ServiceCode
                WHERE jsp.JobID = @JobID AND js.ServiceCode = 'FULL_BODY_PAINT';
            END
        END

        /* ----------------------------
           6) If job moved to Completed/Closed -> run finalization hooks
           - generate invoice stub, lock parts consumption, notify customer, etc.
        ---------------------------- */
        IF @NewStatus IN ('Completed','Closed')
        BEGIN
            -- Example: set JobCompletedDate if not set
            UPDATE dbo.Jobs
            SET JobCompletedDate = COALESCE(JobCompletedDate, @Now)
            WHERE JobID = @JobID;

            -- Optionally mark JobServices as Completed
            IF OBJECT_ID('dbo.JobServices','U') IS NOT NULL
            BEGIN
                UPDATE dbo.JobServices
                SET ServiceStatus = CASE WHEN ISNULL(ServiceStatus,'') = '' THEN 'Completed' ELSE ServiceStatus END,
                    ServiceCompletedDate = COALESCE(ServiceCompletedDate, @Now)
                WHERE JobID = @JobID AND ServiceStatus NOT IN ('Cancelled','Completed');
            END

            -- Optional: create invoice placeholder
            IF OBJECT_ID('dbo.Invoices','U') IS NOT NULL AND OBJECT_ID('dbo.sp_CreateInvoiceFromJob','P') IS NOT NULL
            BEGIN
                -- NOTE: some teams prefer to create invoice in separate flow; this is optional
                EXEC dbo.sp_CreateInvoiceFromJob @JobID = @JobID, @CreatedBy = @PerformedByUserID;
            END
        END

        /* ----------------------------
           7) Notification hook
        ---------------------------- */
        IF OBJECT_ID('dbo.sp_NotifyJobStatusChanged','P') IS NOT NULL
        BEGIN
            EXEC dbo.sp_NotifyJobStatusChanged @JobID = @JobID, @OldStatus = @OldStatus, @NewStatus = @NewStatus, @ChangedBy = @PerformedByUserID;
        END

        /* ----------------------------
           8) Output and finalize
        ---------------------------- */
        COMMIT TRANSACTION;

        SET @OutJobID = @JobID;
        SET @OutOldStatus = @OldStatus;
        SET @OutNewStatus = @NewStatus;

        SELECT @OutJobID AS JobID, @OutOldStatus AS OldStatus, @OutNewStatus AS NewStatus, GETDATE() AS ProcessedAt;
        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrNo INT = ERROR_NUMBER();
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrState INT = ERROR_STATE();

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = CONCAT('Error(', @ErrNo, '): ', @ErrMsg);
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN @ErrNo;
    END CATCH
END
GO
