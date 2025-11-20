/***************************************************************
  160_sp_GetJobCardDetails — Enterprise version
  - Returns a full, single-row job header plus detail result sets:
    1) Job Header (single row)
    2) Customer
    3) Vehicle
    4) JobServices (each service)
    5) JobServicePanels (if any)
    6) Estimate header + EstimateItems
    7) Insurance claim (if any) + claim documents
    8) JobStatusHistory
    9) Job photos / attachments (if table exists)
  - Enforces strict branch separation (A1.1) unless @IsAdmin = 1
  - Designed to be consumed by Technician app, Customer app, and Admin UIs
  - Output: multiple resultsets for easy client consumption
  - Author: ChatGPT — adapt column names if your schema differs
***************************************************************/

SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.160_sp_GetJobCardDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.160_sp_GetJobCardDetails;
GO

CREATE PROCEDURE dbo.160_sp_GetJobCardDetails
(
    @RequestedByUserID INT,
    @IsAdmin BIT = 0,
    @JobID INT
)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
        @UserBranchID INT,
        @JobBranchID INT;

    -- Basic validation
    IF @JobID IS NULL OR @JobID <= 0
    BEGIN
        RAISERROR('JobID is required.', 16, 1);
        RETURN 50001;
    END

    -- Resolve user branch
    SELECT @UserBranchID = BranchID FROM dbo.Users WHERE UserID = @RequestedByUserID;
    IF @UserBranchID IS NULL
    BEGIN
        RAISERROR('Invalid RequestedByUserID or user has no branch assigned.', 16, 1);
        RETURN 50002;
    END

    -- Resolve job branch and basic header
    IF NOT EXISTS (SELECT 1 FROM dbo.Jobs WHERE JobID = @JobID)
    BEGIN
        RAISERROR('Job not found: %d', 16, 1, @JobID);
        RETURN 50003;
    END

    SELECT @JobBranchID = BranchID FROM dbo.Jobs WHERE JobID = @JobID;

    -- Enforce strict branch separation unless admin
    IF (@IsAdmin = 0 AND @UserBranchID <> @JobBranchID)
    BEGIN
        RAISERROR('Branch mismatch: not authorized to read this job.',16,1);
        RETURN 50004;
    END

    -- 1) Job Header
    SELECT
        j.JobID,
        j.JobCardNumber,
        j.BranchID,
        b.BranchCode,
        b.BranchName,
        j.CustomerID,
        c.CustomerName,
        c.Phone        AS CustomerPhone,
        c.Email        AS CustomerEmail,
        c.Address      AS CustomerAddress,
        j.VehicleID,
        v.RegNo        AS VehicleRegNo,
        v.Make         AS VehicleMake,
        v.Model        AS VehicleModel,
        v.Variant      AS VehicleVariant,
        v.Category     AS VehicleCategory,
        j.JobDate,
        j.PreferredDeliveryDate,
        j.EstimatedDeliveryDate,
        j.ActualDeliveryDate,
        j.JobStatus,
        j.CurrentStage,
        j.PriorityType,
        j.PriorityCharge,
        j.IsInsuranceJob,
        j.InsuranceClaimID,
        j.InternalTowingRequest,
        j.Remarks,
        j.CreatedBy,
        uj.UserName    AS CreatedByName,
        j.CreatedDate,
        j.LastStatusUpdatedBy,
        us.UserName    AS LastStatusUpdatedByName,
        j.LastStatusUpdatedDate
    FROM dbo.Jobs j
    LEFT JOIN dbo.Branches b ON b.BranchID = j.BranchID
    LEFT JOIN dbo.Customers c ON c.CustomerID = j.CustomerID
    LEFT JOIN dbo.Vehicles v ON v.VehicleID = j.VehicleID
    LEFT JOIN dbo.Users uj ON uj.UserID = j.CreatedBy
    LEFT JOIN dbo.Users us ON us.UserID = j.LastStatusUpdatedBy
    WHERE j.JobID = @JobID;

    -- 2) JobServices (all services for this job)
    SELECT
        js.JobServiceID,
        js.JobID,
        js.ServiceCode,
        js.ServiceName,
        js.Qty,
        js.UnitPrice,
        js.TotalPrice,
        js.IsPackage,
        js.IsFullBody,
        js.VehicleCategory,
        js.ServiceStatus,
        js.ServiceAssignedTechnicianID,
        t.UserName AS AssignedTechnicianName,
        js.ServiceCreatedDate = js.CreatedDate,
        js.Notes
    FROM dbo.JobServices js
    LEFT JOIN dbo.Users t ON t.UserID = js.ServiceAssignedTechnicianID
    WHERE js.JobID = @JobID
    ORDER BY js.JobServiceID;

    -- 3) JobServicePanels (if exists)
    IF OBJECT_ID('dbo.JobServicePanels','U') IS NOT NULL
    BEGIN
        SELECT
            jsp.JobServicePanelID,
            jsp.JobID,
            jsp.ServiceCode,
            jsp.PanelName,
            jsp.PanelSequence,
            jsp.PanelStatus,
            jsp.QCReadyDate,
            jsp.PanelAssignedTo,
            u.UserName AS PanelAssignedToName,
            jsp.CreatedDate
        FROM dbo.JobServicePanels jsp
        LEFT JOIN dbo.Users u ON u.UserID = jsp.PanelAssignedTo
        WHERE jsp.JobID = @JobID
        ORDER BY jsp.PanelSequence;
    END

    -- 4) Estimate Header (latest estimate for job) + EstimateItems
    IF OBJECT_ID('dbo.Estimates','U') IS NOT NULL
    BEGIN
        DECLARE @EstimateID INT = NULL;
        SELECT TOP 1 @EstimateID = EstimateID
        FROM dbo.Estimates
        WHERE JobID = @JobID
        ORDER BY EstimateDate DESC, EstimateID DESC;

        IF @EstimateID IS NOT NULL
        BEGIN
            SELECT
                e.EstimateID,
                e.JobID,
                e.BranchID,
                e.EstimateDate,
                e.CreatedBy,
                eu.UserName AS CreatedByName,
                e.Remarks,
                e.SubTotal,
                e.TotalDiscount,
                e.TotalGST,
                e.GrandTotal
            FROM dbo.Estimates e
            LEFT JOIN dbo.Users eu ON eu.UserID = e.CreatedBy
            WHERE e.EstimateID = @EstimateID;

            -- Items
            SELECT
                ei.EstimateItemID,
                ei.EstimateID,
                ei.ServiceType,
                ei.ItemName,
                ei.ItemCode,
                ei.Qty,
                ei.UnitPrice,
                ei.LineTotal,
                ei.DiscountAmount,
                ei.DiscountedTotal,
                ei.GSTPercent,
                ei.GSTAmount,
                ei.FinalAmount,
                ei.IsFullBody,
                ei.PanelName,
                ei.ProductID,
                ei.Notes
            FROM dbo.EstimateItems ei
            WHERE ei.EstimateID = @EstimateID
            ORDER BY ei.EstimateItemID;
        END
        ELSE
        BEGIN
            -- Return empty resultset for estimate header and items
            SELECT CAST(NULL AS INT) AS EstimateID, CAST(NULL AS INT) AS JobID, CAST(NULL AS INT) AS BranchID, CAST(NULL AS DATETIME) AS EstimateDate, CAST(NULL AS INT) AS CreatedBy, CAST(NULL AS NVARCHAR(200)) AS CreatedByName, CAST(NULL AS VARCHAR(MAX)) AS Remarks, CAST(NULL AS DECIMAL(18,2)) AS SubTotal, CAST(NULL AS DECIMAL(18,2)) AS TotalDiscount, CAST(NULL AS DECIMAL(18,2)) AS TotalGST, CAST(NULL AS DECIMAL(18,2)) AS GrandTotal
                WHERE 1 = 0; -- empty set
        END
    END

    -- 5) Insurance information (if any)
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
            ic.CreatedDate,
            ic.ModifiedBy,
            um.UserName AS ModifiedByName,
            ic.ModifiedDate
        FROM dbo.InsuranceClaims ic
        LEFT JOIN dbo.Users u ON u.UserID = ic.CreatedBy
        LEFT JOIN dbo.Users um ON um.UserID = ic.ModifiedBy
        WHERE ic.JobID = @JobID;

        -- Claim documents (if table exists)
        IF OBJECT_ID('dbo.ClaimDocuments','U') IS NOT NULL
        BEGIN
            SELECT
                cd.ClaimDocumentID,
                cd.InsuranceClaimID,
                cd.DocumentType,
                cd.FileName,
                cd.FilePath,
                cd.UploadedBy,
                uu.UserName AS UploadedByName,
                cd.UploadedDate
            FROM dbo.ClaimDocuments cd
            LEFT JOIN dbo.Users uu ON uu.UserID = cd.UploadedBy
            WHERE cd.InsuranceClaimID IN (SELECT InsuranceClaimID FROM dbo.InsuranceClaims WHERE JobID = @JobID);
        END
    END

    -- 6) Job Status History (timeline)
    IF OBJECT_ID('dbo.JobStatusHistory','U') IS NOT NULL
    BEGIN
        SELECT
            jsh.JobStatusHistoryID,
            jsh.JobID,
            jsh.OldStatus,
            jsh.NewStatus,
            jsh.ChangedBy,
            u.UserName AS ChangedByName,
            jsh.ChangedDate,
            jsh.Remarks
        FROM dbo.JobStatusHistory jsh
        LEFT JOIN dbo.Users u ON u.UserID = jsh.ChangedBy
        WHERE jsh.JobID = @JobID
        ORDER BY jsh.ChangedDate ASC, jsh.JobStatusHistoryID ASC;
    END

    -- 7) Job Attachments / Photos (if exists)
    IF OBJECT_ID('dbo.JobPhotos','U') IS NOT NULL
    BEGIN
        SELECT
            jp.JobPhotoID,
            jp.JobID,
            jp.PhotoType,
            jp.FileName,
            jp.FilePath,
            jp.UploadedBy,
            uu.UserName AS UploadedByName,
            jp.UploadedDate,
            jp.Notes
        FROM dbo.JobPhotos jp
        LEFT JOIN dbo.Users uu ON uu.UserID = jp.UploadedBy
        WHERE jp.JobID = @JobID
        ORDER BY jp.UploadedDate;
    END

    -- 8) Final supplementary info: related active tasks, QC checks (optional)
    IF OBJECT_ID('dbo.JobTasks','U') IS NOT NULL
    BEGIN
        SELECT
            jt.JobTaskID,
            jt.JobID,
            jt.TaskName,
            jt.TaskStatus,
            jt.AssignedTo,
            u.UserName AS AssignedToName,
            jt.DueDate
        FROM dbo.JobTasks jt
        LEFT JOIN dbo.Users u ON u.UserID = jt.AssignedTo
        WHERE jt.JobID = @JobID
        ORDER BY jt.JobTaskID;
    END

    RETURN 0;
END
GO
