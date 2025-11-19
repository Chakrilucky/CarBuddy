SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TechnicianWorkloadSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- 1. MAIN WORKLOAD SUMMARY FOR EACH TECHNICIAN
    --------------------------------------------------------------------
    SELECT 
        u.UserID AS TechnicianID,
        u.FullName AS TechnicianName,

        COUNT(j.JobCardID) AS TotalAssignedJobs,

        SUM(CASE WHEN j.JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS CompletedJobs,

        SUM(CASE WHEN j.JobStatus NOT IN ('Delivered','Cancelled') THEN 1 ELSE 0 END) AS PendingJobs,

        SUM(CASE WHEN CAST(j.CreatedDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS TodayAssignedJobs
    FROM Users u
    LEFT JOIN JobCards j 
        ON j.AssignedTechnicianID = u.UserID
        AND j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    WHERE 
        u.Role = 'Technician'
        AND u.BranchID = @BranchID
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        TotalAssignedJobs DESC;



    --------------------------------------------------------------------
    -- 2. DETAILED JOB LIST PER TECHNICIAN
    --------------------------------------------------------------------
    SELECT 
        j.JobCardID,
        j.JobCardNumber,
        u.FullName AS TechnicianName,
        j.JobStatus,
        j.CreatedDate,
        j.CompletedOn
    FROM JobCards j
    LEFT JOIN Users u ON u.UserID = j.AssignedTechnicianID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND u.Role = 'Technician'
    ORDER BY 
        u.FullName, j.CreatedDate DESC;

END

GO
