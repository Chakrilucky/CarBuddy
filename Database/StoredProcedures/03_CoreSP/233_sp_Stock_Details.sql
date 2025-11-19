SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Stock_Details]
(
    @PartID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- 1) Basic Part Information
    ---------------------------------------------------------
    SELECT 
        P.PartID,
        P.PartName,
        P.PartCode,
        P.PartType,
        P.Description,
        P.Unit,
        P.HSNCode,
        P.CostPrice,
        P.SellingPrice,
        P.StockQuantity,
        P.ReorderLevel,
        P.VendorID,
        P.CreatedDate,
        P.UpdatedDate,
        CASE 
            WHEN P.StockQuantity <= 0 THEN 'Out of Stock'
            WHEN P.StockQuantity <= P.ReorderLevel THEN 'Low Stock'
            ELSE 'In Stock'
        END AS StockStatus
    FROM InventoryParts P
    WHERE P.PartID = @PartID
      AND P.BranchID = @BranchID;

    ---------------------------------------------------------
    -- 2) Complete Stock Movement History
    ---------------------------------------------------------
    SELECT 
        L.StockLogID,
        L.TransactionType,       -- IN / OUT
        L.Source,                -- Purchase / JobCard / Adjustment
        L.Quantity,
        L.StockBefore,
        L.StockAfter,
        L.CreatedDate
    FROM InventoryStockLogs L
    WHERE L.PartID = @PartID
      AND L.BranchID = @BranchID
    ORDER BY L.CreatedDate DESC;
END;

GO
