
/***************************************************************
  150_sp_GetEstimateDetails — Enterprise version (Estimate Module)
  - Multiple resultsets: Estimate Header, Estimate Items, Job Info, Customer, Vehicle, Estimate History, Insurance (if any)
  - Uses tables: JobEstimates, JobEstimateItems, JobCards, Customers, Vehicles, InsuranceClaims
  - Enforces strict branch separation (A1.1) unless @IsAdmin = 1
  - Author: ChatGPT (adapt column names if your schema differs)
***************************************************************/

SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.150_sp_GetEstimateDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.150_sp_GetEstimateDetails;
GO

CREATE PROCEDURE dbo.150_sp_GetEstimateDetails
(
    @RequestedByUserID INT,
    @IsAdmin BIT = 0,
    @EstimateID INT = NULL,
    @JobID INT = NULL
)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE @UserBranchID INT, @EstimateBranchID INT, @JobBranchID INT, @ResolvedEstimateID INT;

    -- Basic resolution: prefer EstimateID if provided, else find latest estimate for JobID
    IF @EstimateID IS NULL AND @JobID IS NULL
    BEGIN
        RAISERROR('Either EstimateID or JobID must be provided.',16,1);
        RETURN 50001;
    END

    SELECT @UserBranchID = BranchID FROM dbo.Users WHERE UserID = @RequestedByUserID;
    IF @UserBranchID IS NULL
    BEGIN
        RAISERROR('Invalid RequestedByUserID or user has no branch assigned.',16,1);
        RETURN 50002;
    END

    IF @EstimateID IS NULL
    BEGIN
        SELECT TOP 1 @ResolvedEstimateID = EstimateID FROM dbo.JobEstimates WHERE JobID = @JobID ORDER BY EstimateDate DESC, EstimateID DESC;
        IF @ResolvedEstimateID IS NULL
        BEGIN
            RAISERROR('No estimates found for JobID %d',16,1,@JobID);
            RETURN 50003;
        END
    END
    ELSE
        SET @ResolvedEstimateID = @EstimateID;

    -- Check estimate exists and get branch
    IF NOT EXISTS (SELECT 1 FROM dbo.JobEstimates WHERE EstimateID = @ResolvedEstimateID)
    BEGIN
        RAISERROR('Estimate not found: %d',16,1,@ResolvedEstimateID);
        RETURN 50004;
    END

    SELECT @EstimateBranchID = BranchID, @JobID = JobID FROM dbo.JobEstimates WHERE EstimateID = @ResolvedEstimateID;

    -- Determine job branch if job exists
    IF @JobID IS NOT NULL AND @JobBranchID IS NULL AND OBJECT_ID('dbo.JobCards','U') IS NOT NULL
    BEGIN
        SELECT @JobBranchID = BranchID FROM dbo.JobCards WHERE JobID = @JobID;
    END

    -- Effective branch for permission: prefer Estimate branch, else Job branch
    DECLARE @EffectiveBranchID INT = COALESCE(@EstimateBranchID, @JobBranchID, @UserBranchID);

    -- Enforce strict branch separation unless admin
    IF (@IsAdmin = 0 AND @UserBranchID <> @EffectiveBranchID)
    BEGIN
        RAISERROR('Branch mismatch: not authorized to read this estimate.',16,1);
        RETURN 50005;
    END

    /* 1) Estimate Header */
    SELECT
        e.EstimateID,
        e.JobID,
        e.BranchID,
        b.BranchCode,
        b.BranchName,
        e.EstimateDate,
        e.CreatedBy,
        uc.UserName AS CreatedByName,
        e.Remarks,
        e.SubTotal,
        e.TotalDiscount,
        e.TotalGST,
        e.GrandTotal,
        e.EstimateStatus
    FROM dbo.JobEstimates e
    LEFT JOIN dbo.Branches b ON b.BranchID = e.BranchID
    LEFT JOIN dbo.Users uc ON uc.UserID = e.CreatedBy
    WHERE e.EstimateID = @ResolvedEstimateID;

    /* 2) Estimate Items */
    SELECT
        i.EstimateItemID,
        i.EstimateID,
        i.ServiceType,
        i.ItemName,
        i.ItemCode,
        i.Qty,
        i.UnitPrice,
        i.LineTotal,
        i.DiscountAmount,
        i.DiscountedTotal,
        i.GSTPercent,
        i.GSTAmount,
        i.FinalAmount,
        i.IsFullBody,
        i.PanelName,
        i.ProductID,
        i.Notes
    FROM dbo.JobEstimateItems i
    WHERE i.EstimateID = @ResolvedEstimateID
    ORDER BY i.EstimateItemID;

    /* 3) Job information (if linked) */
    IF OBJECT_ID('dbo.JobCards','U') IS NOT NULL
    BEGIN
        SELECT
            j.JobID,
            j.JobCardNumber,
            j.BranchID,
            j.JobDate,
            j.JobStatus,
            j.CurrentStage,
            j.PriorityType,
            j.PriorityCharge,
            j.CustomerID,
            c.CustomerName,
            c.Phone AS CustomerPhone,
            v.VehicleID,
            v.RegNo AS VehicleRegNo,
            v.Make AS VehicleMake,
            v.Model AS VehicleModel
        FROM dbo.JobCards j
        LEFT JOIN dbo.Customers c ON c.CustomerID = j.CustomerID
        LEFT JOIN dbo.Vehicles v ON v.VehicleID = j.VehicleID
        WHERE j.JobID = @JobID;
    END

    /* 4) Estimate History */
    IF OBJECT_ID('dbo.EstimateHistory','U') IS NOT NULL
    BEGIN
        SELECT
            eh.EstimateHistoryID,
            eh.EstimateID,
            eh.EventType,
            eh.Notes,
            eh.ChangedBy,
            u.UserName AS ChangedByName,
            eh.ChangedDate
        FROM dbo.EstimateHistory eh
        LEFT JOIN dbo.Users u ON u.UserID = eh.ChangedBy
        WHERE eh.EstimateID = @ResolvedEstimateID
        ORDER BY eh.ChangedDate ASC, eh.EstimateHistoryID ASC;
    END

    /* 5) Insurance info (if linked) */
    IF OBJECT_ID('dbo.InsuranceClaims','U') IS NOT NULL
    BEGIN
        SELECT
            ic.InsuranceClaimID,
            ic.JobID,
            ic.InsuranceCompanyID,
            ic.PolicyNumber,
            ic.ClaimReference,
            ic.ClaimStatus,
            ic.ClaimNotes,
            ic.CreatedBy,
            u.UserName AS CreatedByName,
            ic.CreatedDate
        FROM dbo.InsuranceClaims ic
        LEFT JOIN dbo.Users u ON u.UserID = ic.CreatedBy
        WHERE ic.JobID = @JobID;
    END

    RETURN 0;
END
GO
