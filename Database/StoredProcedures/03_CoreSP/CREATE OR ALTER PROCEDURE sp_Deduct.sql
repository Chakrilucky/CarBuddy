CREATE OR ALTER PROCEDURE sp_DeductInventoryOnJobCompletion
    @JobCardId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* 1️⃣ Ensure material usage exists */
        IF NOT EXISTS (
            SELECT 1
            FROM JobCardMaterialUsage
            WHERE JobCardId = @JobCardId
        )
        BEGIN
            RAISERROR ('No material usage found for this Job Card.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 2️⃣ Check stock availability */
        IF EXISTS (
            SELECT 1
            FROM JobCardMaterialUsage JMU
            JOIN InventoryParts IP
                ON IP.PartID = JMU.PartID
            WHERE JMU.JobCardId = @JobCardId
              AND ISNULL(IP.StockQuantity, 0) < JMU.QuantityUsed
        )
        BEGIN
            RAISERROR ('Insufficient stock for one or more inventory items.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 3️⃣ Insert stock logs FIRST (with before & after) */
        INSERT INTO InventoryStockLogs
        (
            PartID,
            JobCardID,
            TransactionType,
            Source,
            Quantity,
            StockBefore,
            StockAfter,
            Notes
        )
        SELECT
            IP.PartID,
            @JobCardId,
            'OUT',
            'Job',
            JMU.QuantityUsed,
            IP.StockQuantity,
            IP.StockQuantity - JMU.QuantityUsed,
            CONCAT('JobCard Consumption - JobCardId ', @JobCardId)
        FROM JobCardMaterialUsage JMU
        JOIN InventoryParts IP
            ON IP.PartID = JMU.PartID
        WHERE JMU.JobCardId = @JobCardId;

        /* 4️⃣ Deduct stock */
        UPDATE IP
        SET IP.StockQuantity = IP.StockQuantity - JMU.QuantityUsed
        FROM InventoryParts IP
        JOIN JobCardMaterialUsage JMU
            ON IP.PartID = JMU.PartID
        WHERE JMU.JobCardId = @JobCardId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT 
            @ErrMsg = ERROR_MESSAGE(),
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR (@ErrMsg, @ErrSeverity, 1);
    END CATCH
END;
GO
