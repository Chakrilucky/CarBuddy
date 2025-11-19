SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_QCPendingSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------------
    -- 1. TOTAL QC PENDING COUNT
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS QCPendingCount
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus = 'QCPending'
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate;



    ------------------------------------------------------------------------
    -- 2. QC PENDING AGE ANALYSIS
    -- How long each vehicle has been waiting for QC
    ------------------------------------------------------------------------
    SELECT 
        j.JobCardID,
        j.JobCardNumber,
        j.VehicleID,
        j.CreatedDate,
        DATEDIFF(HOUR, j.CreatedDate, GETDATE()) AS WaitingHours,
        DATEDIFF(DAY, j.CreatedDate, GETDATE()) AS WaitingDays,
        j.AssignedTechnicianID,
        u.FullName AS TechnicianName
    FROM JobCards j
    LEFT JOIN Users u ON u.UserID = j.AssignedTechnicianID
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus = 'QCPending'
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        WaitingHours DESC;



    ------------------------------------------------------------------------
    -- 3. QC PENDING COUNT BY TECHNICIAN
    ------------------------------------------------------------------------
    SELECT 
        ISNULL(u.FullName, 'Unassigned') AS TechnicianName,
        COUNT(*) AS TotalPending
    FROM JobCards j
    LEFT JOIN Users u ON u.UserID = j.AssignedTechnicianID
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus = 'QCPending'
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        u.FullName
    ORDER BY 
        TotalPending DESC;

END

GO
