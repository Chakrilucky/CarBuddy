SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_AverageBillingPerCustomer]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- 1. OVERALL AVERAGE BILLING PER CUSTOMER
    --------------------------------------------------------------------
    SELECT 
        AVG(CustomerTotalBilling) AS AvgBillingPerCustomer
    FROM 
    (
        SELECT 
            j.CustomerID,
            SUM(i.NetAmount) AS CustomerTotalBilling
        FROM JobCards j
        INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
        WHERE 
            j.BranchID = @BranchID
            AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        GROUP BY 
            j.CustomerID
    ) AS BillingSummary;



    --------------------------------------------------------------------
    -- 2. LIST OF CUSTOMERS WITH TOTAL BILLING
    --------------------------------------------------------------------
    SELECT 
        c.CustomerID,
        c.FullName,
        SUM(i.NetAmount) AS TotalBilling,
        COUNT(j.JobCardID) AS TotalVisits,
        AVG(i.NetAmount) AS AvgBillPerVisit
    FROM JobCards j
    INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
    INNER JOIN Customers c ON j.CustomerID = c.CustomerID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        c.CustomerID, c.FullName
    ORDER BY 
        TotalBilling DESC;

END

GO
