SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Stock_GetLogByPart]
    @PartID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        L.StockLogID,
        L.PartID,
        P.PartName,
        L.TransactionType,     -- IN / OUT
        L.Source,              -- Purchase / JobCard / Adjustment
        L.Quantity,
        L.StockBefore,
        L.StockAfter,
        L.CreatedDate,
        L.BranchID
    FROM InventoryStockLogs L
    INNER JOIN InventoryParts P ON L.PartID = P.PartID
    WHERE L.PartID = @PartID
      AND L.BranchID = @BranchID
    ORDER BY L.CreatedDate DESC;
END;

GO
