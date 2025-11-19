SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_StockReturn_Add]
(
    @VendorID INT,
    @PurchaseID INT = NULL,
    @PartID INT,
    @QuantityReturned DECIMAL(18,2),
    @ReturnReason NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------
    -- 1) Validate Part exists
    -----------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1 FROM InventoryParts 
        WHERE PartID = @PartID AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('Invalid PartID for this branch.', 16, 1);
        RETURN;
    END

    -----------------------------------------------------------
    -- 2) Check Stock Availability
    -----------------------------------------------------------
    DECLARE @CurrentStock DECIMAL(18,2);

    SELECT @CurrentStock = StockQuantity
    FROM InventoryParts
    WHERE PartID = @PartID AND BranchID = @BranchID;

    IF @CurrentStock < @QuantityReturned
    BEGIN
        RAISERROR('Insufficient stock to return.', 16, 1);
        RETURN;
    END

    -----------------------------------------------------------
    -- 3) Insert return record
    -----------------------------------------------------------
    INSERT INTO StockReturns
    (
        VendorID,
        PurchaseID,
        PartID,
        QuantityReturned,
        ReturnReason,
        ReturnDate,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @VendorID,
        @PurchaseID,
        @PartID,
        @QuantityReturned,
        @ReturnReason,
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    DECLARE @ReturnID INT = SCOPE_IDENTITY();

    -----------------------------------------------------------
    -- 4) Update Inventory (Reduce Stock)
    -----------------------------------------------------------
    UPDATE InventoryParts
    SET StockQuantity = StockQuantity - @QuantityReturned,
        UpdatedDate = GETDATE()
    WHERE PartID = @PartID AND BranchID = @BranchID;

    -----------------------------------------------------------
    -- 5) Insert stock log entry (OUT - Return)
    -----------------------------------------------------------
    INSERT INTO InventoryStockLogs
    (
        PartID,
        TransactionType,
        Source,
        Quantity,
        StockBefore,
        StockAfter,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @PartID,
        'OUT',
        'ReturnToVendor',
        @QuantityReturned,
        @CurrentStock,
        @CurrentStock - @QuantityReturned,
        GETDATE(),
        @BranchID
    );

    -----------------------------------------------------------
    -- Return ID for UI confirmation
    -----------------------------------------------------------
    SELECT @ReturnID AS ReturnID;
END;

GO
