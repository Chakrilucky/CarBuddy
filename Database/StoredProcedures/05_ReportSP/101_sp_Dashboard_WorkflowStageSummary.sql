SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_WorkflowStageSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- WORKFLOW STAGE SUMMARY
    --------------------------------------------------------------------
    SELECT 
        j.JobStatus,
        COUNT(*) AS TotalJobs
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.JobStatus
    ORDER BY 
        TotalJobs DESC;



    --------------------------------------------------------------------
    -- DETAILED STAGE BREAKDOWN (For Charts)
    --------------------------------------------------------------------
    SELECT 
        j.JobStatus,
        FORMAT(j.CreatedDate, 'yyyy-MM') AS MonthName,
        COUNT(*) AS JobsInStage
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.JobStatus,
        FORMAT(j.CreatedDate, 'yyyy-MM')
    ORDER BY 
        MonthName, JobStatus;

END

GO
