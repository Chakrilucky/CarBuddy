SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Stock_AddFromPurchase]
    @PartID INT,
    @PurchaseID INT,
    @Quantity DECIMAL(18,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update stock
    UPDATE InventoryParts
    SET StockQuantity = StockQuantity + @Quantity
    WHERE PartID = @PartID AND BranchID = @BranchID;

    -- Insert log
    INSERT INTO InventoryStockLogs
    (
        PartID, PurchaseID, TransactionType, Source,
        Quantity, StockBefore, StockAfter,
        CreatedDate, BranchID
    )
    SELECT
        @PartID,
        @PurchaseID,
        'IN',
        'Purchase',
        @Quantity,
        StockQuantity - @Quantity,
        StockQuantity,
        GETDATE(),
        @BranchID
    FROM InventoryParts
    WHERE PartID = @PartID AND BranchID = @BranchID;
END;

GO
