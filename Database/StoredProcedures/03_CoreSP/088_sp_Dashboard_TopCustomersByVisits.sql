SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopCustomersByVisits]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        c.CustomerID,
        c.FullName,
        c.MobileNumber,
        COUNT(j.JobCardID) AS VisitCount,
        MIN(j.CreatedDate) AS FirstVisitDate,
        MAX(j.CreatedDate) AS LastVisitDate
    FROM JobCards j
    INNER JOIN Customers c ON j.CustomerID = c.CustomerID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        c.CustomerID, c.FullName, c.MobileNumber
    ORDER BY 
        VisitCount DESC;
END

GO
