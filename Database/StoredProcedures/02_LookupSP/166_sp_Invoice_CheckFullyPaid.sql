SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Invoice_CheckFullyPaid]
(
    @InvoiceID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GrandTotal DECIMAL(18,2) =
    (SELECT GrandTotal FROM JobInvoices WHERE InvoiceID = @InvoiceID);

    DECLARE @Paid DECIMAL(18,2) =
    (
        SELECT SUM(AmountPaid)
        FROM Payments
        WHERE InvoiceID = @InvoiceID
    );

    IF @Paid >= @GrandTotal
    BEGIN
        UPDATE JobCards
        SET JobStatus = 'Ready For Delivery',
            UpdatedDate = GETDATE()
        WHERE JobCardID = (SELECT JobCardID FROM JobInvoices WHERE InvoiceID = @InvoiceID);
    END;
END;

GO
