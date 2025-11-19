SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InventoryLowStockSummary]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------------
    -- 1. PARTS BELOW REORDER LEVEL
    -----------------------------------------------------------------------
    SELECT 
        PartID,
        PartName,
        PartNumber,
        CurrentStock,
        ReorderLevel,
        (ReorderLevel - CurrentStock) AS RequiredQuantity
    FROM SpareParts
    WHERE 
        CurrentStock < ReorderLevel
    ORDER BY 
        CurrentStock ASC;



    -----------------------------------------------------------------------
    -- 2. PARTS OUT OF STOCK (Stock = 0)
    -----------------------------------------------------------------------
    SELECT 
        PartID,
        PartName,
        PartNumber,
        CurrentStock
    FROM SpareParts
    WHERE 
        CurrentStock = 0
    ORDER BY 
        PartName;



    -----------------------------------------------------------------------
    -- 3. TOP 10 MOST CRITICAL PARTS
    -----------------------------------------------------------------------
    SELECT TOP 10
        PartID,
        PartName,
        CurrentStock,
        ReorderLevel,
        (ReorderLevel - CurrentStock) AS Shortage
    FROM SpareParts
    WHERE 
        CurrentStock < ReorderLevel
    ORDER BY 
        Shortage DESC;

END

GO
