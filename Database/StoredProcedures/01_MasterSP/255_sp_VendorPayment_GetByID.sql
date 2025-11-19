SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VendorPayment_GetByID]
(
    @VendorPaymentID INT,
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
        VP.CreatedDate,
        VP.UpdatedDate
    FROM VendorPayments VP
    LEFT JOIN Vendors V ON VP.VendorID = V.VendorID
    LEFT JOIN InventoryPurchases P ON VP.PurchaseID = P.PurchaseID
    WHERE 
        VP.VendorPaymentID = @VendorPaymentID
        AND VP.BranchID = @BranchID;
END;

GO
