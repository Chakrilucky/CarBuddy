SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_PackageItem_Add]
    @PackageID INT,
    @ItemType VARCHAR(50),
    @ItemName NVARCHAR(200),
    @Quantity DECIMAL(10,2),
    @UnitPrice DECIMAL(10,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PackageItems
    (
        PackageID,
        ItemType,
        ItemName,
        Quantity,
        UnitPrice,
        BranchID
        -- ❌ NO TotalPrice here (it is computed automatically)
    )
    VALUES
    (
        @PackageID,
        @ItemType,
        @ItemName,
        @Quantity,
        @UnitPrice,
        @BranchID
    );

END;

GO
