-- sp_AcceptPurchaseInvoice.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_AcceptPurchaseInvoice','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_AcceptPurchaseInvoice;
GO
CREATE PROCEDURE dbo.sp_AcceptPurchaseInvoice
  @InvoiceId INT,
  @AcceptedBy INT
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.PurchaseInvoices
    SET Status = 'ACCEPTED', AcceptedBy = @AcceptedBy, AcceptedAt = SYSUTCDATETIME()
  WHERE InvoiceId = @InvoiceId;

  SELECT 1 AS Success, @InvoiceId AS InvoiceId;
END
GO
