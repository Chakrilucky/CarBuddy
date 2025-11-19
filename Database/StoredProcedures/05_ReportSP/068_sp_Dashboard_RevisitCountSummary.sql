SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_RevisitCountSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    --------------------------------------------------------------------
    -- 1. VEHICLE-WISE REVISIT COUNT
    --------------------------------------------------------------------
    SELECT 
        j.VehicleID,
        COUNT(j.JobCardID) AS VisitCount
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.VehicleID
    HAVING COUNT(j.JobCardID) > 1
    ORDER BY 
        VisitCount DESC;



    --------------------------------------------------------------------
    -- 2. CUSTOMER-WISE REVISIT COUNT
    --------------------------------------------------------------------
    SELECT 
        j.CustomerID,
        COUNT(j.JobCardID) AS VisitCount
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.CustomerID
    HAVING COUNT(j.JobCardID) > 1
    ORDER BY 
        VisitCount DESC;



    --------------------------------------------------------------------
    -- 3. DETAILED REVISIT TIMELINE (Vehicle History)
    --------------------------------------------------------------------
    SELECT 
        j.VehicleID,
        j.JobCardID,
        j.JobCardNumber,
        j.CreatedDate,
        LAG(j.CreatedDate, 1) OVER (PARTITION BY j.VehicleID ORDER BY j.CreatedDate) AS PreviousVisitDate,
        DATEDIFF(DAY, 
            LAG(j.CreatedDate, 1) OVER (PARTITION BY j.VehicleID ORDER BY j.CreatedDate), 
            j.CreatedDate) AS DaysBetweenVisits
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        j.VehicleID, j.CreatedDate;

END

GO
