SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PartUsage_Add]
    @JobCardID INT,
    @PartID INT,
    @QuantityUsed DECIMAL(18,2),
    @UsedByTechnicianID INT = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CurrentStock DECIMAL(18,2);
        DECLARE @UnitPrice DECIMAL(18,2);

        -- Get existing stock
        SELECT 
            @CurrentStock = StockQuantity,
            @UnitPrice = CostPrice
        FROM InventoryParts
        WHERE PartID = @PartID AND BranchID = @BranchID;

        -- Validate part
        IF @CurrentStock IS NULL
        BEGIN
            RAISERROR ('Invalid PartID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Stock availability check
        IF @CurrentStock < @QuantityUsed
        BEGIN
            RAISERROR ('Not enough stock available.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        --------------------------------------------------------
        -- INSERT PartUsageTracking **WITHOUT TotalPrice**
        --------------------------------------------------------
        INSERT INTO PartUsageTracking
        (
            JobCardID, PartID, QuantityUsed,
            UnitPrice, UsedByTechnicianID,
            UsageDate, CreatedDate, BranchID
        )
        VALUES
        (
            @JobCardID, @PartID, @QuantityUsed,
            @UnitPrice, @UsedByTechnicianID,
            GETDATE(), GETDATE(), @BranchID
        );

        --------------------------------------------------------
        -- Deduct stock from InventoryParts
        --------------------------------------------------------
        UPDATE InventoryParts
        SET StockQuantity = StockQuantity - @QuantityUsed,
            UpdatedDate = GETDATE()
        WHERE PartID = @PartID AND BranchID = @BranchID;

        --------------------------------------------------------
        -- Add Stock Log
        --------------------------------------------------------
        INSERT INTO InventoryStockLogs
        (
            PartID, JobCardID, TransactionType, Source,
            Quantity, StockBefore, StockAfter,
            Notes, CreatedDate, BranchID
        )
        VALUES
        (
            @PartID, @JobCardID, 'OUT', 'JobCard',
            @QuantityUsed, @CurrentStock, @CurrentStock - @QuantityUsed,
            'Used in job card', GETDATE(), @BranchID
        );

        COMMIT TRANSACTION;

        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO
