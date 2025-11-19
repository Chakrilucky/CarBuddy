SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_BranchPerformanceComparison]
(
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------------
    -- 1. MAIN BRANCH PERFORMANCE SUMMARY
    -----------------------------------------------------------------------
    SELECT 
        b.BranchID,
        b.BranchName,

        -- Total jobs created
        COUNT(j.JobCardID) AS TotalJobs,

        -- Delivered jobs
        SUM(CASE WHEN j.JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS DeliveredJobs,

        -- Pending jobs
        SUM(CASE WHEN j.JobStatus NOT IN ('Delivered','Cancelled') THEN 1 ELSE 0 END) AS PendingJobs,

        -- Avg TAT (hours)
        AVG(CASE 
            WHEN j.JobStatus = 'Delivered' AND j.CompletedOn IS NOT NULL 
            THEN DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn) 
        END) AS AvgTATHours,

        -- Approx Revenue (Placeholder until Invoice integration)
        SUM(CASE WHEN j.JobStatus = 'Delivered' THEN 1 ELSE 0 END) * 1 AS ApproxRevenue

    FROM Branches b
    LEFT JOIN JobCards j ON j.BranchID = b.BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        b.BranchID, b.BranchName
    ORDER BY 
        b.BranchID;



    -----------------------------------------------------------------------
    -- 2. TECHNICIAN COUNT PER BRANCH
    -----------------------------------------------------------------------
    SELECT 
        BranchID,
        COUNT(*) AS TechnicianCount
    FROM Users
    WHERE Role = 'Technician'
    GROUP BY BranchID
    ORDER BY BranchID;



    -----------------------------------------------------------------------
    -- 3. INSURANCE CLAIM LOAD PER BRANCH
    -----------------------------------------------------------------------
    SELECT 
        j.BranchID,
        COUNT(c.InsuranceClaimID) AS TotalClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Approved' THEN 1 ELSE 0 END) AS ApprovedClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Rejected' THEN 1 ELSE 0 END) AS RejectedClaims
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON j.JobCardID = c.JobCardID
    WHERE 
        j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.BranchID
    ORDER BY 
        j.BranchID;

END

GO
