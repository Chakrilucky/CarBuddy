SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GRN_Add]
(
    @PurchaseID INT,
    @GRNNumber NVARCHAR(50),
    @ReceivedDate DATETIME2,
    @Notes NVARCHAR(MAX) = NULL,
    @Items XML,                -- List of parts with quantity & unitcost
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------
    -- Validate Purchase exists for this branch
    ----------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM InventoryPurchases 
                   WHERE PurchaseID = @PurchaseID AND BranchID = @BranchID)
    BEGIN
        RAISERROR('Invalid PurchaseID for this branch.', 16, 1);
        RETURN;
    END

    ----------------------------------------------------
    -- 1) INSERT GRN HEADER
    ----------------------------------------------------
    INSERT INTO GoodsReceivedNotes
    (
        PurchaseID,
        GRNNumber,
        ReceivedDate,
        Notes,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @PurchaseID,
        @GRNNumber,
        @ReceivedDate,
        @Notes,
        GETDATE(),
        @BranchID
    );

    DECLARE @GRNID INT = SCOPE_IDENTITY();

    ----------------------------------------------------
    -- 2) READ XML ITEMS
    -- XML Format expected:
    -- <Items>
    --   <Item PartID="1" Quantity="5" UnitCost="200" />
    --   <Item PartID="2" Quantity="2" UnitCost="350" />
    -- </Items>
    ----------------------------------------------------
    DECLARE @PartID INT,
            @Qty DECIMAL(18,2),
            @UnitCost DECIMAL(18,2);

    DECLARE cur CURSOR FOR 
    SELECT  
        T.X.value('@PartID','INT'),
        T.X.value('@Quantity','DECIMAL(18,2)'),
        T.X.value('@UnitCost','DECIMAL(18,2)')
    FROM @Items.nodes('/Items/Item') AS T(X);

    OPEN cur;
    FETCH NEXT FROM cur INTO @PartID, @Qty, @UnitCost;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        ---------------------------------------------------------
        -- Validate PartID existence
        ---------------------------------------------------------
        IF NOT EXISTS (SELECT 1 FROM InventoryParts 
                       WHERE PartID = @PartID AND BranchID = @BranchID)
        BEGIN
            RAISERROR('Invalid PartID for this branch.', 16, 1);
            CLOSE cur;
            DEALLOCATE cur;
            RETURN;
        END

        ---------------------------------------------------------
        -- 3) INSERT ITEM INTO GoodsReceivedItems
        ---------------------------------------------------------
        INSERT INTO GoodsReceivedItems
        (
            GRNID,
            PartID,
            QuantityReceived,
            UnitCost,
            BranchID
        )
        VALUES
        (
            @GRNID,
            @PartID,
            @Qty,
            @UnitCost,
            @BranchID
        );

        ---------------------------------------------------------
        -- 4) Update Inventory Stock
        ---------------------------------------------------------
        UPDATE InventoryParts
        SET 
            StockQuantity = StockQuantity + @Qty,
            UpdatedDate = GETDATE()
        WHERE PartID = @PartID AND BranchID = @BranchID;

        ---------------------------------------------------------
        -- 5) Insert Stock Log (IN)
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
        SELECT 
            @PartID,
            'IN',
            'GRN',
            @Qty,
            StockQuantity - @Qty,     -- previous stock
            StockQuantity,            -- new stock
            GETDATE(),
            @BranchID
        FROM InventoryParts
        WHERE PartID = @PartID AND BranchID = @BranchID;

        FETCH NEXT FROM cur INTO @PartID, @Qty, @UnitCost;
    END

    CLOSE cur;
    DEALLOCATE cur;

    ---------------------------------------------------------
    -- Return GRN ID
    ---------------------------------------------------------
    SELECT @GRNID AS GRNID;
END;

GO
