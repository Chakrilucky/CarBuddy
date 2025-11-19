SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Part_Search]
(
    @SearchText NVARCHAR(200),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PartID, PartName, PartType, PartCode,
           StockQuantity, SellingPrice
    FROM InventoryParts
    WHERE BranchID = @BranchID
      AND (
            PartName LIKE '%' + @SearchText + '%' OR
            PartCode LIKE '%' + @SearchText + '%' OR
            PartType LIKE '%' + @SearchText + '%'
          );
END;

GO
