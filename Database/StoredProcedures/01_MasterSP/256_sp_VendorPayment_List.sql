SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VendorPayment_List]
(
    @VendorID INT = NULL,
    @PurchaseID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        VP.VendorPaymentID,
        VP.VendorID,
        V.VendorName,
        VP.PurchaseID,
        P.InvoiceNumber AS PurchaseInvoiceNumber,
        VP.PaymentDate,
        VP.PaymentMethod,
        VP.AmountPaid,
        VP.ReferenceNumber,
        VP.Notes,
        VP.CreatedDate
    FROM VendorPayments VP
    LEFT JOIN Vendors V ON VP.VendorID = V.VendorID
    LEFT JOIN InventoryPurchases P ON VP.PurchaseID = P.PurchaseID
    WHERE 
        VP.BranchID = @BranchID
        AND (@VendorID IS NULL OR VP.VendorID = @VendorID)
        AND (@PurchaseID IS NULL OR VP.PurchaseID = @PurchaseID)
    ORDER BY VP.PaymentDate DESC;
END;

GO
