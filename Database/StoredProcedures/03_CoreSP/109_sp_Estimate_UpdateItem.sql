SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_UpdateItem]
    @EstimateItemID INT,
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @TaxPercent DECIMAL(5,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE EstimateItems
    SET 
        Quantity = @Quantity,
        UnitPrice = @UnitPrice,
        TaxPercent = @TaxPercent,
        UpdatedDate = GETDATE()
    WHERE EstimateItemID = @EstimateItemID
      AND BranchID = @BranchID;

    DECLARE @EstimateID INT = (SELECT EstimateID FROM EstimateItems WHERE EstimateItemID = @EstimateItemID);

    EXEC sp_Estimate_RecalculateTotals @EstimateID, @BranchID;

    SELECT 'Updated' AS Result;
END;

GO
