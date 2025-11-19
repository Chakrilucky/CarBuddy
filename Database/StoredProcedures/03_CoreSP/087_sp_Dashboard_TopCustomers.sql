SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopCustomers]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10      -- default top 10 customers
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        c.CustomerID,
        c.FullName,
        c.MobileNumber,
        COUNT(j.JobCardID) AS TotalVisits,
        SUM(i.NetAmount) AS TotalSpent
    FROM Customers c
    INNER JOIN JobCards j 
        ON c.CustomerID = j.CustomerID
    INNER JOIN Invoices i 
        ON j.JobCardID = i.JobCardID
    WHERE 
        c.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        c.CustomerID, c.FullName, c.MobileNumber
    ORDER BY 
        TotalSpent DESC;
END

GO
