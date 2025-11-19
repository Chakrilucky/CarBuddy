SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopVendorsByPurchase]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        s.SupplierID,
        s.SupplierName,
        COUNT(po.PurchaseOrderID) AS TotalOrders,
        SUM(po.TotalAmount) AS TotalPurchaseAmount,
        AVG(CAST(po.TotalAmount AS DECIMAL(10,2))) AS AvgOrderValue
    FROM PurchaseOrders po
    INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID
    WHERE 
        po.BranchID = @BranchID
        AND po.PurchaseDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        s.SupplierID, s.SupplierName
    ORDER BY 
        TotalPurchaseAmount DESC;
END

GO
