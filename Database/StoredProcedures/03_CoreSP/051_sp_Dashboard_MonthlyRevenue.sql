SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_MonthlyRevenue]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  
        FORMAT(InvoiceDate, 'yyyy-MM') AS RevenueMonth,
        SUM(GrandTotal) AS TotalRevenue
    FROM JobInvoices
    WHERE BranchID = @BranchID
    GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
    ORDER BY RevenueMonth;
END;

GO
