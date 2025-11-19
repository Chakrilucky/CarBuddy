SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TechnicianPerformanceSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        u.UserID AS TechnicianID,
        u.FullName AS TechnicianName,

        -- Total jobs assigned
        COUNT(j.JobCardID) AS TotalJobs,

        -- Completed Jobs
        SUM(CASE WHEN j.JobStatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedJobs,

        -- Delivered Jobs
        SUM(CASE WHEN j.JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS DeliveredJobs,

        -- In-progress Jobs
        SUM(CASE WHEN j.JobStatus = 'In-Progress' THEN 1 ELSE 0 END) AS InProgressJobs,

        -- Pending Jobs
        SUM(CASE WHEN j.JobStatus = 'Created' THEN 1 ELSE 0 END) AS PendingJobs
    FROM Users u
    LEFT JOIN JobCards j 
        ON u.UserID = j.AssignedTechnicianID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND j.BranchID = @BranchID
    WHERE 
        u.Role = 'Technician'
        AND u.BranchID = @BranchID
        AND u.IsActive = 1
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        TotalJobs DESC;
END

GO
