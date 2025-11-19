SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Stock_List]
    @BranchID INT,
    @Search NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PartID,
        PartName,
        PartCode,
        PartType,
        Description,
        Unit,
        HSNCode,
        CostPrice,
        SellingPrice,
        StockQuantity,
        ReorderLevel,
        VendorID,
        CreatedDate,
        UpdatedDate,
        BranchID,

        CASE 
            WHEN StockQuantity <= 0 THEN 'Out of Stock'
            WHEN StockQuantity <= ReorderLevel THEN 'Low Stock'
            ELSE 'In Stock'
        END AS StockStatus

    FROM InventoryParts
    WHERE BranchID = @BranchID
      AND (
            @Search IS NULL
            OR PartName LIKE '%' + @Search + '%'
            OR PartCode LIKE '%' + @Search + '%'
            OR PartType LIKE '%' + @Search + '%'
            OR Description LIKE '%' + @Search + '%'
          )
    ORDER BY PartName ASC;
END;

GO
