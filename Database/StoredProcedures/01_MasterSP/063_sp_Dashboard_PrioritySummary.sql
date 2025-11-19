SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PrioritySummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. PRIORITY WISE JOB COUNT
    SELECT 
        pt.PriorityName,
        COUNT(j.JobCardID) AS JobCount
    FROM JobCards j
    INNER JOIN PriorityTypes pt
        ON j.PriorityTypeID = pt.PriorityTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        pt.PriorityName
    ORDER BY 
        JobCount DESC;



    -- 2. PRIORITY REVENUE SPLIT
    SELECT 
        pt.PriorityName,
        SUM(i.NetAmount) AS Revenue
    FROM Invoices i
    INNER JOIN JobCards j
        ON i.JobCardID = j.JobCardID
    INNER JOIN PriorityTypes pt
        ON j.PriorityTypeID = pt.PriorityTypeID
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        pt.PriorityName
    ORDER BY 
        Revenue DESC;



    -- 3. PREMIUM JOBS TODAY
    SELECT 
        COUNT(*) AS PremiumJobsToday
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND PriorityTypeID = 2
        AND CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE);



    -- 4. PREMIUM PENDING JOBS
    SELECT 
        COUNT(*) AS PremiumPending
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND PriorityTypeID = 2
        AND JobStatus NOT IN ('Delivered', 'Cancelled');
END

GO
