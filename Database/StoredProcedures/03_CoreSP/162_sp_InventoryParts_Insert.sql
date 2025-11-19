SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InventoryParts_Insert]
    @PartName NVARCHAR(200),
    @PartCode NVARCHAR(100),
    @PartType VARCHAR(50),
    @Description NVARCHAR(MAX),
    @Unit NVARCHAR(50),
    @HSNCode NVARCHAR(20),
    @CostPrice DECIMAL(18,2),
    @SellingPrice DECIMAL(18,2),
    @StockQuantity DECIMAL(18,2),
    @ReorderLevel DECIMAL(18,2),
    @VendorID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate part name check
    IF EXISTS (SELECT 1 FROM InventoryParts 
               WHERE PartName = @PartName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Part already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO InventoryParts
    (
        PartName, PartCode, PartType, Description, Unit,
        HSNCode, CostPrice, SellingPrice, StockQuantity,
        ReorderLevel, VendorID, CreatedDate, BranchID
    )
    VALUES
    (
        @PartName, @PartCode, @PartType, @Description, @Unit,
        @HSNCode, @CostPrice, @SellingPrice, @StockQuantity,
        @ReorderLevel, @VendorID, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PartID;
END;

GO
