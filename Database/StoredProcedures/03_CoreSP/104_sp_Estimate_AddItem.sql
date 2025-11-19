SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_AddItem]
    @EstimateID INT,
    @ItemType VARCHAR(50),      -- Labour / Part / Other
    @ItemName NVARCHAR(200),
    @ItemDescription NVARCHAR(MAX),
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @TaxPercent DECIMAL(5,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------
    -- Insert estimate item (TotalPrice computed)
    ---------------------------------------------------
    INSERT INTO EstimateItems
    (
        EstimateID, ItemType, ItemName, ItemDescription,
        Quantity, UnitPrice, TaxPercent,
        CreatedDate, BranchID
    )
    VALUES
    (
        @EstimateID, @ItemType, @ItemName, @ItemDescription,
        @Quantity, @UnitPrice, @TaxPercent,
        GETDATE(), @BranchID
    );

    ---------------------------------------------------
    -- Recalculate Estimate Totals
    ---------------------------------------------------
    EXEC sp_Estimate_RecalculateTotals @EstimateID, @BranchID;

    SELECT SCOPE_IDENTITY() AS EstimateItemID;
END;

GO
