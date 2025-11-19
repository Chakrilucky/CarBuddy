SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_EstimateVsActualSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------
    -- 1. SUMMARY: ESTIMATE VS ACTUAL
    -------------------------------------------------------
    SELECT 
        COUNT(e.JobCardID) AS TotalEstimatedJobs,

        SUM(e.EstimatedAmount) AS TotalEstimatedAmount,
        SUM(i.NetAmount) AS TotalActualAmount,

        SUM(i.NetAmount) - SUM(e.EstimatedAmount) AS TotalDifference,

        CASE 
            WHEN SUM(e.EstimatedAmount) = 0 THEN 0
            ELSE 
                ((SUM(e.EstimatedAmount) * 100.0) / SUM(i.NetAmount))
        END AS EstimationAccuracyPercentage
    FROM JobEstimates e
    INNER JOIN Invoices i ON e.JobCardID = i.JobCardID
    WHERE 
        e.BranchID = @BranchID
        AND e.CreatedDate BETWEEN @FromDate AND @ToDate;



    -------------------------------------------------------
    -- 2. JOB WISE ESTIMATE VS ACTUAL LIST
    -------------------------------------------------------
    SELECT 
        j.JobCardID,
        st.ServiceName,
        e.EstimatedAmount,
        i.NetAmount AS ActualAmount,
        (i.NetAmount - e.EstimatedAmount) AS Difference,
        j.CreatedDate
    FROM JobEstimates e
    INNER JOIN Invoices i ON e.JobCardID = i.JobCardID
    INNER JOIN JobCards j ON e.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        e.BranchID = @BranchID
        AND e.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        j.CreatedDate DESC;



    -------------------------------------------------------
    -- 3. UNDER-ESTIMATED JOBS
    -------------------------------------------------------
    SELECT 
        COUNT(*) AS UnderEstimatedJobs
    FROM JobEstimates e
    INNER JOIN Invoices i ON e.JobCardID = i.JobCardID
    WHERE 
        e.BranchID = @BranchID
        AND e.CreatedDate BETWEEN @FromDate AND @ToDate
        AND i.NetAmount > e.EstimatedAmount;



    -------------------------------------------------------
    -- 4. OVER-ESTIMATED JOBS
    -------------------------------------------------------
    SELECT 
        COUNT(*) AS OverEstimatedJobs
    FROM JobEstimates e
    INNER JOIN Invoices i ON e.JobCardID = i.JobCardID
    WHERE 
        e.BranchID = @BranchID
        AND e.CreatedDate BETWEEN @FromDate AND @ToDate
        AND e.EstimatedAmount > i.NetAmount;

END

GO
