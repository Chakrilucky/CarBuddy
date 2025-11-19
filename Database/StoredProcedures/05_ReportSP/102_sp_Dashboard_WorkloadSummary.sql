SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_WorkloadSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- MAIN WORKSHOP SUMMARY
    SELECT 
        COUNT(*) AS TotalJobs,
        SUM(CASE WHEN j.JobStatus = 'Created' THEN 1 ELSE 0 END) AS NewJobs,
        SUM(CASE WHEN j.JobStatus = 'In-Progress' THEN 1 ELSE 0 END) AS InProgress,
        SUM(CASE WHEN j.JobStatus = 'Completed' THEN 1 ELSE 0 END) AS Completed,
        SUM(CASE WHEN j.JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS Delivered,
        SUM(CASE WHEN j.JobStatus = 'Hold' THEN 1 ELSE 0 END) AS OnHold,
        SUM(CASE WHEN j.InsuranceClaimID IS NOT NULL THEN 1 ELSE 0 END) AS InsuranceJobs
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate;


    -- CATEGORY WISE LOAD (MECH / PAINT / AC / ELECTRICAL)
    SELECT 
        st.Category,
        COUNT(j.JobCardID) AS TotalJobs
    FROM JobCards j
    INNER JOIN ServiceTypes st
        ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.Category
    ORDER BY 
        TotalJobs DESC;
END

GO
