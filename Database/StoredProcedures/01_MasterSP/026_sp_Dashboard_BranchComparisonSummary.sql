SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_BranchComparisonSummary]
(
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        b.BranchID,
        b.BranchName,

        -- Total Job Cards
        (SELECT COUNT(*) 
         FROM JobCards j 
         WHERE j.BranchID = b.BranchID
           AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS TotalJobs,

        -- Completed Jobs
        (SELECT COUNT(*) 
         FROM JobCards j 
         WHERE j.BranchID = b.BranchID
           AND j.JobStatus = 'Completed'
           AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS CompletedJobs,

        -- Delivered Jobs
        (SELECT COUNT(*) 
         FROM JobCards j 
         WHERE j.BranchID = b.BranchID
           AND j.JobStatus = 'Delivered'
           AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS DeliveredJobs,

        -- Pending Jobs
        (SELECT COUNT(*) 
         FROM JobCards j 
         WHERE j.BranchID = b.BranchID
           AND j.JobStatus NOT IN ('Delivered', 'Cancelled')
           AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS PendingJobs,

        -- Revenue
        (SELECT SUM(i.NetAmount)
         FROM Invoices i
         WHERE i.BranchID = b.BranchID
           AND i.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS TotalRevenue,

        -- New Customers
        (SELECT COUNT(*) 
         FROM Customers c 
         WHERE c.BranchID = b.BranchID
           AND c.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS NewCustomers

    FROM Branches b
    ORDER BY TotalJobs DESC;
END

GO
