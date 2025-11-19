SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobCompletionSpeedTrend]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- MONTH-WISE AVERAGE JOB COMPLETION TIME (IN HOURS)
    --------------------------------------------------------------------
    SELECT
        FORMAT(j.CompletedOn, 'yyyy-MM') AS MonthName,
        
        AVG(
            DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
        ) AS AvgCompletionHours,
        
        MIN(
            DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
        ) AS FastestCompletionHours,
        
        MAX(
            DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
        ) AS SlowestCompletionHours,

        COUNT(*) AS CompletedJobs
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus = 'Delivered'
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        FORMAT(j.CompletedOn, 'yyyy-MM')
    ORDER BY 
        MonthName ASC;

END

GO
