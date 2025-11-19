SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ServiceTypeTurnaroundSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------------
    -- SERVICE TYPE WISE TURNAROUND TIME
    -----------------------------------------------------------------------
    SELECT 
        st.ServiceName,
        
        AVG(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS AvgTATHours,
        MIN(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS FastestTATHours,
        MAX(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS SlowestTATHours,

        COUNT(j.JobCardID) AS TotalCompletedJobs
    FROM JobCards j
    INNER JOIN ServiceTypes st ON st.ServiceTypeID = j.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus = 'Delivered'
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        AvgTATHours ASC;   -- fastest service first

END

GO
