SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Stock_Adjust]
(
    @PartID INT,
    @AdjustmentType VARCHAR(10),     -- 'IN' or 'OUT'
    @Quantity DECIMAL(18,2),
    @Reason NVARCHAR(500),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldStock DECIMAL(18,2);
    DECLARE @NewStock DECIMAL(18,2);

    -- Get current stock
    SELECT @OldStock = StockQuantity
    FROM InventoryParts
    WHERE PartID = @PartID AND BranchID = @BranchID;

    IF @OldStock IS NULL
    BEGIN
        RAISERROR ('Invalid PartID or BranchID.', 16, 1);
        RETURN;
    END

    ---------------------------------------------------------
    -- Calculate new stock
    ---------------------------------------------------------
    IF @AdjustmentType = 'IN'
        SET @NewStock = @OldStock + @Quantity;

    ELSE IF @AdjustmentType = 'OUT'
        SET @NewStock = @OldStock - @Quantity;

    ELSE
    BEGIN
        RAISERROR ('AdjustmentType must be IN or OUT.', 16, 1);
        RETURN;
    END

    ---------------------------------------------------------
    -- Prevent negative stock
    ---------------------------------------------------------
    IF @NewStock < 0
    BEGIN
        RAISERROR ('Stock cannot go below zero.', 16, 1);
        RETURN;
    END

    ---------------------------------------------------------
    -- Update stock in InventoryParts
    ---------------------------------------------------------
    UPDATE InventoryParts
    SET 
        StockQuantity = @NewStock,
        UpdatedDate = GETDATE()
    WHERE PartID = @PartID AND BranchID = @BranchID;

    ---------------------------------------------------------
    -- Insert stock adjustment log
    ---------------------------------------------------------
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
        @AdjustmentType,
        @Reason,
        @Quantity,
        @OldStock,
        @NewStock,
        GETDATE(),
        @BranchID
    );
END;

GO
