SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PartsStockStatus]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------
    -- 1. OUT OF STOCK ITEMS
    ----------------------------------------------------
    SELECT 
        ItemID,
        ItemName,
        Category,
        QuantityInStock
    FROM InventoryItems
    WHERE 
        BranchID = @BranchID
        AND IsActive = 1
        AND QuantityInStock = 0
    ORDER BY ItemName;



    ----------------------------------------------------
    -- 2. LOW STOCK ITEMS (Quantity <= ReorderLevel)
    ----------------------------------------------------
    SELECT 
        ItemID,
        ItemName,
        Category,
        QuantityInStock,
        ReorderLevel
    FROM InventoryItems
    WHERE 
        BranchID = @BranchID
        AND IsActive = 1
        AND QuantityInStock > 0
        AND QuantityInStock <= ReorderLevel
    ORDER BY QuantityInStock ASC;



    ----------------------------------------------------
    -- 3. FAST MOVING ITEMS (based on JobParts consumption)
    ----------------------------------------------------
    SELECT 
        i.ItemID,
        i.ItemName,
        i.Category,
        SUM(jp.Quantity) AS TotalUsed
    FROM JobParts jp
    INNER JOIN InventoryItems i ON jp.ItemID = i.ItemID
    INNER JOIN JobCards j ON jp.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND i.IsActive = 1
    GROUP BY 
        i.ItemID, i.ItemName, i.Category
    ORDER BY 
        TotalUsed DESC;



    ----------------------------------------------------
    -- 4. TOTAL STOCK VALUE FOR BRANCH
    ----------------------------------------------------
    SELECT 
        SUM(QuantityInStock * UnitPrice) AS TotalStockValue,
        COUNT(*) AS TotalItems
    FROM InventoryItems
    WHERE 
        BranchID = @BranchID
        AND IsActive = 1;
END

GO
