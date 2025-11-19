SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Purchase_AddItem]
    @PurchaseID INT,
    @PartID INT,
    @Quantity DECIMAL(18,2),
    @UnitCost DECIMAL(18,2),
    @GSTPercent DECIMAL(18,2) = 0,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GSTAmount DECIMAL(18,2) =
            (@Quantity * @UnitCost * @GSTPercent / 100);

    -- Insert item
    INSERT INTO InventoryPurchaseItems
    (
        PurchaseID, PartID, Quantity, UnitCost,
        GSTPercent, GSTAmount, Notes,
        CreatedDate, BranchID
    )
    VALUES
    (
        @PurchaseID, @PartID, @Quantity, @UnitCost,
        @GSTPercent, @GSTAmount, @Notes,
        GETDATE(), @BranchID
    );

    -- Update totals
    EXEC sp_Purchase_UpdateTotals @PurchaseID, @BranchID;

    -- Update stock
    EXEC sp_Stock_AddFromPurchase 
        @PartID, @PurchaseID, @Quantity, @BranchID;
END;

GO
