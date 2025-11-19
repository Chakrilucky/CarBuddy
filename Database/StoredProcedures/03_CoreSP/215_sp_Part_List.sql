SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Part_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PartID, PartName, PartType, PartCode,
           StockQuantity, SellingPrice, ReorderLevel
    FROM InventoryParts
    WHERE BranchID = @BranchID
    ORDER BY PartName;
END;

GO
