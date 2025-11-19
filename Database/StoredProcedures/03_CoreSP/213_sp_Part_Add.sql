SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Part_Add]
(
    @PartName NVARCHAR(200),
    @PartType VARCHAR(50),
    @PartCode NVARCHAR(100) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @Unit NVARCHAR(50),
    @HSNCode NVARCHAR(20) = NULL,
    @CostPrice DECIMAL(18,2),
    @SellingPrice DECIMAL(18,2),
    @StockQuantity DECIMAL(18,2),
    @ReorderLevel DECIMAL(18,2),
    @VendorID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InventoryParts
    (
        PartName, PartType, PartCode, Description,
        Unit, HSNCode, CostPrice, SellingPrice,
        StockQuantity, ReorderLevel, VendorID,
        CreatedDate, BranchID
    )
    VALUES
    (
        @PartName, @PartType, @PartCode, @Description,
        @Unit, @HSNCode, @CostPrice, @SellingPrice,
        @StockQuantity, @ReorderLevel, @VendorID,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PartID;
END;

GO
