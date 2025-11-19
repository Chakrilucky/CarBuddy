SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_MonthlyRevenueTrend]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Months AS
    (
        SELECT DATEADD(MONTH, -11, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) AS StartMonth
        UNION ALL
        SELECT DATEADD(MONTH, 1, StartMonth)
        FROM Months
        WHERE DATEADD(MONTH, 1, StartMonth) <= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
    )
    SELECT 
        FORMAT(m.StartMonth, 'yyyy-MM') AS MonthName,
        ISNULL(SUM(p.AmountPaid), 0) AS TotalRevenue
    FROM Months m
        LEFT JOIN JobInvoicePayments p 
            ON YEAR(p.PaymentDate) = YEAR(m.StartMonth)
           AND MONTH(p.PaymentDate) = MONTH(m.StartMonth)
        LEFT JOIN JobInvoices inv ON p.InvoiceID = inv.InvoiceID
        LEFT JOIN JobCards jc ON inv.JobCardID = jc.JobCardID AND jc.BranchID = @BranchID
    GROUP BY m.StartMonth
    ORDER BY m.StartMonth;
END;

GO
