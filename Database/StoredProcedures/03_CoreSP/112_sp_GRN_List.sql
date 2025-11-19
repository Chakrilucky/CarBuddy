SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GRN_List]
(
    @BranchID INT,
    @VendorID INT = NULL,
    @PurchaseID INT = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        GRN.GRNID,
        GRN.GRNNumber,
        GRN.ReceivedDate,
        GRN.PurchaseID,
        P.InvoiceNumber AS PurchaseInvoiceNumber,
        P.VendorID,
        V.VendorName,

        -- Total quantity received for display
        (
            SELECT SUM(QuantityReceived)
            FROM GoodsReceivedItems I
            WHERE I.GRNID = GRN.GRNID
        ) AS TotalItemsReceived,

        GRN.Notes,
        GRN.CreatedDate,
        GRN.BranchID
    FROM GoodsReceivedNotes GRN
    LEFT JOIN InventoryPurchases P ON GRN.PurchaseID = P.PurchaseID
    LEFT JOIN Vendors V ON P.VendorID = V.VendorID
    WHERE 
        GRN.BranchID = @BranchID
        AND (@VendorID IS NULL OR P.VendorID = @VendorID)
        AND (@PurchaseID IS NULL OR GRN.PurchaseID = @PurchaseID)
        AND (@FromDate IS NULL OR CAST(GRN.ReceivedDate AS DATE) >= @FromDate)
        AND (@ToDate IS NULL OR CAST(GRN.ReceivedDate AS DATE) <= @ToDate)
    ORDER BY GRN.ReceivedDate DESC, GRN.GRNID DESC;
END;

GO
