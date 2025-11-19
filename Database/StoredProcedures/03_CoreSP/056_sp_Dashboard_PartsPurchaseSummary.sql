SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PartsPurchaseSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- 1. TOTAL PURCHASE SUMMARY
    ------------------------------------------------------------
    SELECT 
        SUM(po.TotalAmount) AS TotalPurchaseAmount,
        COUNT(po.PurchaseOrderID) AS TotalPurchaseOrders
    FROM PurchaseOrders po
    WHERE 
        po.BranchID = @BranchID
        AND po.PurchaseDate BETWEEN @FromDate AND @ToDate;



    ------------------------------------------------------------
    -- 2. CATEGORY-WISE PURCHASE SUMMARY
    ------------------------------------------------------------
    SELECT 
        i.Category,
        SUM(poi.TotalPrice) AS TotalCost,
        SUM(poi.Quantity) AS TotalQuantity
    FROM PurchaseOrderItems poi
    INNER JOIN InventoryItems i ON poi.ItemID = i.ItemID
    INNER JOIN PurchaseOrders po ON poi.PurchaseOrderID = po.PurchaseOrderID
    WHERE 
        po.BranchID = @BranchID
        AND po.PurchaseDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        i.Category
    ORDER BY 
        TotalCost DESC;



    ------------------------------------------------------------
    -- 3. SUPPLIER-WISE PURCHASE SUMMARY
    ------------------------------------------------------------
    SELECT 
        s.SupplierID,
        s.SupplierName,
        SUM(po.TotalAmount) AS TotalPurchasedAmount,
        COUNT(po.PurchaseOrderID) AS OrdersCount
    FROM PurchaseOrders po
    INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID
    WHERE 
        po.BranchID = @BranchID
        AND po.PurchaseDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        s.SupplierID, s.SupplierName
    ORDER BY 
        TotalPurchasedAmount DESC;



    ------------------------------------------------------------
    -- 4. RECENT PURCHASE LIST
    ------------------------------------------------------------
    SELECT 
        po.PurchaseOrderID,
        po.PurchaseDate,
        s.SupplierName,
        po.TotalAmount
    FROM PurchaseOrders po
    INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID
    WHERE 
        po.BranchID = @BranchID
        AND po.PurchaseDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        po.PurchaseDate DESC;
END

GO
