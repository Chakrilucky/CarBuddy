SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_NewVsReturningCustomers]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    --------------------------------------------------------------------
    -- 1. LIST OF CUSTOMERS WHO VISITED DURING DATE RANGE
    --------------------------------------------------------------------
    ;WITH AllVisits AS
    (
        SELECT 
            j.CustomerID,
            j.CreatedDate
        FROM JobCards j
        WHERE 
            j.BranchID = @BranchID
            AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ),

    FirstVisit AS
    (
        SELECT 
            j.CustomerID,
            MIN(j.CreatedDate) AS FirstVisitDate
        FROM JobCards j
        WHERE j.BranchID = @BranchID
        GROUP BY j.CustomerID
    )

    SELECT
        SUM(CASE WHEN a.CreatedDate = f.FirstVisitDate THEN 1 ELSE 0 END) AS NewCustomers,
        SUM(CASE WHEN a.CreatedDate <> f.FirstVisitDate THEN 1 ELSE 0 END) AS ReturningCustomers,
        COUNT(*) AS TotalCustomersVisited
    FROM AllVisits a
    INNER JOIN FirstVisit f ON a.CustomerID = f.CustomerID;



    --------------------------------------------------------------------
    -- 2. MONTH-WISE NEW VS RETURNING CUSTOMERS TREND
    --------------------------------------------------------------------
    SELECT
        FORMAT(a.CreatedDate, 'yyyy-MM') AS MonthName,

        SUM(CASE WHEN a.CreatedDate = f.FirstVisitDate THEN 1 ELSE 0 END) AS NewCustomers,
        SUM(CASE WHEN a.CreatedDate <> f.FirstVisitDate THEN 1 ELSE 0 END) AS ReturningCustomers
    FROM AllVisits a
    INNER JOIN FirstVisit f ON a.CustomerID = f.CustomerID
    GROUP BY FORMAT(a.CreatedDate, 'yyyy-MM')
    ORDER BY MonthName;

END

GO
