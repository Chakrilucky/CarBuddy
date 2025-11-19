SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Purchase_UpdateTotals]
    @PurchaseID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @Total DECIMAL(18,2) = 0,
        @GST DECIMAL(18,2) = 0,
        @sql NVARCHAR(MAX) = N'UPDATE InventoryPurchases SET ',
        @SetList NVARCHAR(MAX) = N'',
        @Where NVARCHAR(200) = N' WHERE PurchaseID = ' + CAST(@PurchaseID AS NVARCHAR) +
                               N' AND BranchID = ' + CAST(@BranchID AS NVARCHAR);

    -- Calculate totals
    SELECT 
        @Total = SUM(ISNULL(UnitCost * Quantity,0)),
        @GST = SUM(ISNULL(GSTAmount,0))
    FROM InventoryPurchaseItems
    WHERE PurchaseID = @PurchaseID AND BranchID = @BranchID;

    -- CASE 1: TotalCost column is NOT computed → include it in update
    IF COLUMNPROPERTY(OBJECT_ID('InventoryPurchases'), 'TotalCost', 'IsComputed') = 0
    BEGIN
        SET @SetList = @SetList + N'TotalCost = ' + CAST(@Total AS NVARCHAR(50)) + N',';
    END

    -- CASE 2: GSTAmount column is NOT computed → include it
    IF COLUMNPROPERTY(OBJECT_ID('InventoryPurchases'), 'GSTAmount', 'IsComputed') = 0
    BEGIN
        SET @SetList = @SetList + N'GSTAmount = ' + CAST(@GST AS NVARCHAR(50)) + N',';
    END

    -- Remove last comma
    IF RIGHT(@SetList,1) = ','
        SET @SetList = LEFT(@SetList, LEN(@SetList)-1);

    -- If nothing to update → exit
    IF LEN(@SetList) = 0
    BEGIN
        RETURN;
    END

    -- Build final SQL
    SET @sql = @sql + @SetList + @Where;

    -- Execute dynamic update
    EXEC sp_executesql @sql;
END;

GO
