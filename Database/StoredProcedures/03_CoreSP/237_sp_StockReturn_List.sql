SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_StockReturn_List]
(
    @BranchID INT,
    @VendorID INT = NULL,
    @PurchaseID INT = NULL,
    @PartID INT = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SR.ReturnID,
        SR.ReturnDate,
        SR.VendorID,
        V.VendorName,
        SR.PurchaseID,
        P.InvoiceNumber AS PurchaseInvoiceNumber,
        SR.PartID,
        IP.PartName,
        SR.QuantityReturned,
        SR.ReturnReason,
        SR.CreatedDate,
        SR.BranchID
    FROM StockReturns SR
    LEFT JOIN Vendors V ON SR.VendorID = V.VendorID
    LEFT JOIN InventoryPurchases P ON SR.PurchaseID = P.PurchaseID
    LEFT JOIN InventoryParts IP ON SR.PartID = IP.PartID
    WHERE 
        SR.BranchID = @BranchID
        AND (@VendorID IS NULL OR SR.VendorID = @VendorID)
        AND (@PurchaseID IS NULL OR SR.PurchaseID = @PurchaseID)
        AND (@PartID IS NULL OR SR.PartID = @PartID)
        AND (@FromDate IS NULL OR CAST(SR.ReturnDate AS DATE) >= @FromDate)
        AND (@ToDate IS NULL OR CAST(SR.ReturnDate AS DATE) <= @ToDate)
    ORDER BY SR.ReturnDate DESC, SR.ReturnID DESC;
END;

GO
