SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_VisitFrequencySummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH VisitData AS
    (
        SELECT 
            j.CustomerID,
            COUNT(j.JobCardID) AS VisitCount
        FROM JobCards j
        WHERE 
            j.BranchID = @BranchID
            AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        GROUP BY 
            j.CustomerID
    )

    SELECT 
        SUM(CASE WHEN VisitCount = 1 THEN 1 ELSE 0 END) AS OneTimeVisitors,
        SUM(CASE WHEN VisitCount = 2 THEN 1 ELSE 0 END) AS TwoTimeVisitors,
        SUM(CASE WHEN VisitCount BETWEEN 3 AND 5 THEN 1 ELSE 0 END) AS FrequentVisitors,
        SUM(CASE WHEN VisitCount > 5 THEN 1 ELSE 0 END) AS SuperFrequentVisitors
    FROM VisitData;
END

GO
