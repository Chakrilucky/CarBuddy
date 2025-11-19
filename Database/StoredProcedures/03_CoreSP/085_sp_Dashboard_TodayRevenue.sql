SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodayRevenue]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH InvoiceTotals AS
    (
        SELECT 
            I.InvoiceID,
            I.GrandTotal,
            ISNULL(SUM(P.AmountPaid), 0) AS PaidAmount
        FROM JobInvoices I
        LEFT JOIN JobInvoicePayments P ON I.InvoiceID = P.InvoiceID
        WHERE 
            I.BranchID = @BranchID
            AND CAST(I.InvoiceDate AS DATE) = CAST(GETDATE() AS DATE)
        GROUP BY 
            I.InvoiceID, I.GrandTotal
    )
    SELECT 
        SUM(GrandTotal) AS TotalRevenue,
        SUM(PaidAmount) AS TotalPaid,
        SUM(GrandTotal - PaidAmount) AS TotalPending
    FROM InvoiceTotals;
END;

GO
