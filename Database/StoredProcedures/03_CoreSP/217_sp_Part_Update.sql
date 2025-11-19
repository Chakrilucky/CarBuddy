SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Part_Update]
(
    @PartID INT,
    @PartName NVARCHAR(200),
    @PartType VARCHAR(50),
    @PartCode NVARCHAR(100) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @Unit NVARCHAR(50),
    @HSNCode NVARCHAR(20) = NULL,
    @CostPrice DECIMAL(18,2),
    @SellingPrice DECIMAL(18,2),
    @ReorderLevel DECIMAL(18,2),
    @VendorID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InventoryParts
    SET 
        PartName = @PartName,
        PartType = @PartType,
        PartCode = @PartCode,
        Description = @Description,
        Unit = @Unit,
        HSNCode = @HSNCode,
        CostPrice = @CostPrice,
        SellingPrice = @SellingPrice,
        ReorderLevel = @ReorderLevel,
        VendorID = @VendorID,
        UpdatedDate = GETDATE()
    WHERE PartID = @PartID AND BranchID = @BranchID;
END;

GO
