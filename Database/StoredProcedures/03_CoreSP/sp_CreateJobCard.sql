/*******************************************************
  sp_CreateJobCard — Phase-1 Enterprise Version (Strict Branch Separation)
  - No MRF logic (kept DB columns if present, but SP ignores them)
  - Auto-inserts full-body painting panels from PaintingPanelsMaster -> JobServicePanels
  - Creates Customer / Vehicle when not provided
  - Generates JobCardNumber: BRANCHCODE-YYYYMM-00000
  - Optional Estimate creation
  - Notification hook placeholder: dbo.sp_NotifyNewJob
  - Outputs @OutJobID and @OutJobCardNumber
  - Author: ChatGPT (adapt names to your schema if necessary)
*******************************************************/

IF OBJECT_ID('dbo.sp_CreateJobCard', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CreateJobCard;
GO

CREATE PROCEDURE dbo.sp_CreateJobCard
    -- Caller / permission context
    @CreatedByUserID        INT,
    @IsAdmin                BIT = 0,                 -- admin can override branch separation

    -- Branch and basic job
    @BranchID               INT,
    @JobDate                DATETIME = NULL,         -- if null, GETDATE()
    @PreferredDeliveryDate  DATETIME = NULL,
    @PriorityType           VARCHAR(20) = 'Normal',  -- 'Normal' or 'Premium'
    @PriorityCharge         DECIMAL(10,2) = 0.00,
    @InternalTowingRequest  BIT = 0,

    -- Customer (either provide ID or details to create)
    @CustomerID             INT = NULL,
    @CustomerName           VARCHAR(200) = NULL,
    @CustomerPhone          VARCHAR(50) = NULL,
    @CustomerEmail          VARCHAR(200) = NULL,
    @CustomerAddress        VARCHAR(500) = NULL,

    -- Vehicle (either provide ID or details to create)
    @VehicleID              INT = NULL,
    @VehicleRegNo           VARCHAR(50) = NULL,
    @VehicleMake            VARCHAR(100) = NULL,
    @VehicleModel           VARCHAR(100) = NULL,
    @VehicleVariant         VARCHAR(100) = NULL,
    @VehicleCategory        VARCHAR(20) = NULL,     -- Hatchback/Sedan/SUV etc.
    @VehicleBranchID        INT = NULL,             -- optional override (should normally equal @BranchID)

    -- Basic job meta
    @JobRemarks             VARCHAR(MAX) = NULL,
    @EstimatedDeliveryDate  DATETIME = NULL,

    -- Insurance (if any)
    @IsInsuranceJob         BIT = 0,
    @InsuranceCompanyID     INT = NULL,
    @InsurancePolicyNo      VARCHAR(100) = NULL,
    @InsuranceClaimRef      VARCHAR(100) = NULL,
    @SurveyorRequested      BIT = 0,

    -- Estimate (optional initial estimate)
    @CreateEstimate         BIT = 0,
    @EstimateRemarks        VARCHAR(MAX) = NULL,

    -- Job services JSON (see example in comments)
    @JobServicesJson        NVARCHAR(MAX) = NULL,

    -- Optional: Job source / channel
    @CreatedFrom            VARCHAR(50) = 'WalkIn',  -- e.g., 'App','CallCenter','WalkIn'

    -- OUTPUT
    @OutJobID               INT OUTPUT,
    @OutJobCardNumber       VARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
        @Now DATETIME = ISNULL(@JobDate, GETDATE()),
        @EffectiveBranchID INT,
        @UserBranchID INT,
        @JobID INT,
        @JobCardNumber VARCHAR(100),
        @BranchCode VARCHAR(20),
        @SeqNo INT,
        @ErrorMessage NVARCHAR(4000),
        @YM CHAR(6);

    BEGIN TRY
        BEGIN TRANSACTION;

        /* ----------------------------
           1) Branch/Permission Check — Strict Branch Separation
           ---------------------------- */
        SELECT @UserBranchID = BranchID FROM dbo.Users WHERE UserID = @CreatedByUserID;

        IF @UserBranchID IS NULL
        BEGIN
            RAISERROR('Invalid CreatedByUserID or user has no Branch assigned.', 16, 1);
        END

        -- Determine effective branch: priority: provided VehicleBranchID -> @BranchID param -> user's branch
        SET @EffectiveBranchID = COALESCE(@VehicleBranchID, @BranchID, @UserBranchID);

        -- Strict separation: user must create jobs only for their own branch, unless @IsAdmin = 1
        IF (@IsAdmin = 0) AND (@UserBranchID <> @EffectiveBranchID)
        BEGIN
            RAISERROR('Branch mismatch: user is not allowed to create job for this branch.', 16, 1);
        END

        -- Verify branch exists and fetch branch code
        SELECT TOP 1 @BranchCode = BranchCode FROM dbo.Branches WHERE BranchID = @EffectiveBranchID;
        IF @BranchCode IS NULL
        BEGIN
            RAISERROR('Branch not found for BranchID %d',16,1,@EffectiveBranchID);
        END

        /* ----------------------------
           2) Create or validate Customer
           ---------------------------- */
        IF @CustomerID IS NULL
        BEGIN
            IF ISNULL(LTRIM(RTRIM(@CustomerName)),'') = ''
            BEGIN
                RAISERROR('Customer details missing: either CustomerID or CustomerName required.',16,1);
            END

            INSERT INTO dbo.Customers (CustomerName, Phone, Email, Address, CreatedBy, CreatedDate, BranchID)
            VALUES (@CustomerName, @CustomerPhone, @CustomerEmail, @CustomerAddress, @CreatedByUserID, @Now, @EffectiveBranchID);

            SET @CustomerID = CAST(SCOPE_IDENTITY() AS INT);
        END

        /* ----------------------------
           3) Create or validate Vehicle
           ---------------------------- */
        IF @VehicleID IS NULL
        BEGIN
            IF ISNULL(LTRIM(RTRIM(@VehicleRegNo)), '') = ''
            BEGIN
                RAISERROR('Vehicle details missing: VehicleID or VehicleRegNo required.',16,1);
            END

            INSERT INTO dbo.Vehicles (CustomerID, RegNo, Make, Model, Variant, Category, BranchID, CreatedBy, CreatedDate)
            VALUES (@CustomerID, @VehicleRegNo, @VehicleMake, @VehicleModel, @VehicleVariant, @VehicleCategory, @EffectiveBranchID, @CreatedByUserID, @Now);

            SET @VehicleID = CAST(SCOPE_IDENTITY() AS INT);
        END
        ELSE
        BEGIN
            -- Verify vehicle belongs to branch unless admin
            IF @IsAdmin = 0
            BEGIN
                DECLARE @VehBranch INT;
                SELECT @VehBranch = BranchID FROM dbo.Vehicles WHERE VehicleID = @VehicleID;
                IF @VehBranch IS NOT NULL AND @VehBranch <> @EffectiveBranchID
                BEGIN
                    RAISERROR('Vehicle does not belong to this branch. Use admin to override.',16,1);
                END
            END
        END

        /* ----------------------------
           4) Generate JobCardNumber (BRANCHCODE-YYYYMM-XXXXX)
           ---------------------------- */
        -- Ensure JobSequences exists (minimal fallback)
        IF OBJECT_ID('dbo.JobSequences','U') IS NULL
        BEGIN
            CREATE TABLE dbo.JobSequences (
                BranchID INT NOT NULL,
                YearMonth CHAR(6) NOT NULL, -- YYYYMM
                LastSeq INT NOT NULL,
                CONSTRAINT PK_JobSequences PRIMARY KEY (BranchID, YearMonth)
            );
        END

        SET @YM = CONVERT(CHAR(6), @Now, 112); -- YYYYMM

        -- Update or insert sequence
        UPDATE dbo.JobSequences
        SET LastSeq = LastSeq + 1
        WHERE BranchID = @EffectiveBranchID AND YearMonth = @YM;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO dbo.JobSequences (BranchID, YearMonth, LastSeq) VALUES (@EffectiveBranchID, @YM, 1);
            SET @SeqNo = 1;
        END
        ELSE
        BEGIN
            SELECT @SeqNo = LastSeq FROM dbo.JobSequences WHERE BranchID = @EffectiveBranchID AND YearMonth = @YM;
        END

        SET @JobCardNumber = @BranchCode + '-' + @YM + '-' + RIGHT('00000' + CAST(@SeqNo AS VARCHAR(10)), 5);

        /* ----------------------------
           5) Insert Job main row
           ---------------------------- */
        INSERT INTO dbo.Jobs
            (JobCardNumber, BranchID, CustomerID, VehicleID, CreatedBy, CreatedDate, JobDate,
             PreferredDeliveryDate, EstimatedDeliveryDate, PriorityType, PriorityCharge,
             IsInsuranceJob, InsuranceCompanyID, InsurancePolicyNo, InsuranceClaimRef, SurveyorRequested,
             InternalTowingRequest, JobStatus, Remarks, CreatedFrom)
        VALUES
            (@JobCardNumber, @EffectiveBranchID, @CustomerID, @VehicleID, @CreatedByUserID, @Now, @Now,
             @PreferredDeliveryDate, @EstimatedDeliveryDate, @PriorityType, @PriorityCharge,
             @IsInsuranceJob, @InsuranceCompanyID, @InsurancePolicyNo, @InsuranceClaimRef, @SurveyorRequested,
             @InternalTowingRequest, 'Open', @JobRemarks, @CreatedFrom);

        SET @JobID = CAST(SCOPE_IDENTITY() AS INT);

        /************************************************
         If insurance job, create initial insurance claim record (minimal)
        ************************************************/
        IF @IsInsuranceJob = 1
        BEGIN
            INSERT INTO dbo.InsuranceClaims
                (JobID, BranchID, InsuranceCompanyID, PolicyNumber, ClaimReference, ClaimStatus, CreatedBy, CreatedDate)
            VALUES
                (@JobID, @EffectiveBranchID, @InsuranceCompanyID, @InsurancePolicyNo, @InsuranceClaimRef, 'Initiated', @CreatedByUserID, @Now);

            -- Update Jobs.InsuranceClaimID if Jobs table has that column
            IF COL_LENGTH('dbo.Jobs', 'InsuranceClaimID') IS NOT NULL
            BEGIN
                UPDATE dbo.Jobs
                SET InsuranceClaimID = SCOPE_IDENTITY()
                WHERE JobID = @JobID;
            END
        END

        /************************************************
         Estimate creation (optional)
        ************************************************/
        IF @CreateEstimate = 1
        BEGIN
            INSERT INTO dbo.Estimates
                (JobID, BranchID, EstimateDate, CreatedBy, Remarks, EstimateSource, PriorityCharge)
            VALUES
                (@JobID, @EffectiveBranchID, @Now, @CreatedByUserID, @EstimateRemarks, 
                 CASE WHEN @IsInsuranceJob = 1 THEN 'Insurance' ELSE 'Normal' END, @PriorityCharge);

            DECLARE @EstimateID INT = CAST(SCOPE_IDENTITY() AS INT);
            -- Note: estimate details may be inserted later by separate SP
        END

        /************************************************
         6) Parse and Insert JobServices from JSON
         JSON array expected with keys: ServiceCode, ServiceName, Qty, UnitPrice, IsFullBody
        ************************************************/
        IF ISNULL(LTRIM(RTRIM(@JobServicesJson)), '') <> ''
        BEGIN
            ;WITH parsed AS (
                SELECT
                    JSON_VALUE(value,'$.ServiceCode')    AS ServiceCode,
                    JSON_VALUE(value,'$.ServiceName')    AS ServiceName,
                    TRY_CAST(JSON_VALUE(value,'$.Qty') AS INT) AS Qty,
                    TRY_CAST(JSON_VALUE(value,'$.UnitPrice') AS DECIMAL(18,2)) AS UnitPrice,
                    TRY_CAST(JSON_VALUE(value,'$.IsFullBody') AS BIT) AS IsFullBody,
                    JSON_VALUE(value,'$.VehicleCategory') AS ItemVehicleCategory
                FROM OPENJSON(@JobServicesJson)
            )
            INSERT INTO dbo.JobServices
                (JobID, BranchID, ServiceCode, ServiceName, Qty, UnitPrice, TotalPrice, IsPackage, IsFullBody, VehicleCategory, CreatedBy, CreatedDate)
            SELECT
                @JobID, @EffectiveBranchID,
                ISNULL(ServiceCode, 'UNKNOWN'),
                ServiceName,
                ISNULL(Qty,1),
                ISNULL(UnitPrice,0.00),
                ISNULL(ISNULL(Qty,1) * ISNULL(UnitPrice,0),0),
                0,                            -- IsPackage (could be passed in JSON)
                ISNULL(IsFullBody,0),
                ISNULL(ItemVehicleCategory, @VehicleCategory),
                @CreatedByUserID, @Now
            FROM parsed;
        END

        /************************************************
         7) If any service has IsFullBody=1 or JSON requested full-body,
            ensure a Full Body Painting service exists and auto-insert panels
        ************************************************/
        IF EXISTS (
            SELECT 1 FROM dbo.JobServices WHERE JobID = @JobID AND IsFullBody = 1
        ) = 1
        BEGIN
            -- Ensure the standardized full-body service row exists (ServiceCode 'FULL_BODY_PAINT')
            IF NOT EXISTS (SELECT 1 FROM dbo.JobServices WHERE JobID = @JobID AND ServiceCode = 'FULL_BODY_PAINT')
            BEGIN
                INSERT INTO dbo.JobServices
                    (JobID, BranchID, ServiceCode, ServiceName, Qty, UnitPrice, TotalPrice, IsPackage, IsFullBody, VehicleCategory, CreatedBy, CreatedDate)
                VALUES
                    (@JobID, @EffectiveBranchID, 'FULL_BODY_PAINT', 'Full Body Painting', 1, 0.00, 0.00, 1, 1, @VehicleCategory, @CreatedByUserID, @Now);
            END

            -- Auto-insert panels if JobServicePanels and PaintingPanelsMaster exist
            IF OBJECT_ID('dbo.JobServicePanels','U') IS NOT NULL AND OBJECT_ID('dbo.PaintingPanelsMaster','U') IS NOT NULL
            BEGIN
                -- Avoid duplicates: insert only panels not already present for this job & service
                INSERT INTO dbo.JobServicePanels (JobID, ServiceCode, PanelName, PanelSequence, CreatedBy, CreatedDate)
                SELECT
                    @JobID, 'FULL_BODY_PAINT', ppm.PanelName, ppm.PanelSequence, @CreatedByUserID, @Now
                FROM dbo.PaintingPanelsMaster ppm
                LEFT JOIN dbo.JobServicePanels jsp
                    ON jsp.JobID = @JobID AND jsp.ServiceCode = 'FULL_BODY_PAINT' AND jsp.PanelName = ppm.PanelName
                WHERE ppm.IsActive = 1 AND jsp.JobServicePanelID IS NULL;
            END
        END

        /************************************************
         8) Notification hook (placeholder)
        ************************************************/
        IF OBJECT_ID('dbo.sp_NotifyNewJob','P') IS NOT NULL
        BEGIN
            EXEC dbo.sp_NotifyNewJob @JobID = @JobID, @BranchID = @EffectiveBranchID, @CreatedBy = @CreatedByUserID;
        END

        COMMIT TRANSACTION;

        SET @OutJobID = @JobID;
        SET @OutJobCardNumber = @JobCardNumber;

        SELECT @OutJobID AS JobID, @OutJobCardNumber AS JobCardNumber;
        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrNo INT = ERROR_NUMBER();
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @ErrorMessage = CONCAT('Error(', @ErrNo, '): ', @ErrMsg);
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN @ErrNo;
    END CATCH
END
GO
