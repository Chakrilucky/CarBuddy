SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_LowStockParts]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.PartID,
        P.PartName,
        P.PartCode,
        P.PartType,
        P.StockQuantity,
        P.ReorderLevel,
        P.SellingPrice,
        P.VendorID,
        V.VendorName
    FROM InventoryParts P
    LEFT JOIN Vendors V ON P.VendorID = V.VendorID
    WHERE 
        P.StockQuantity <= P.ReorderLevel
        AND P.BranchID = @BranchID
    ORDER BY 
        P.StockQuantity ASC;  -- lowest stock at top
END;

GO
