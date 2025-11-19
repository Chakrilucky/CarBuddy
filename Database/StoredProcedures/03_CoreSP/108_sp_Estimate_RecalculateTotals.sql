SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_RecalculateTotals]
    @EstimateID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @Parts DECIMAL(18,2) = 0,
        @Labour DECIMAL(18,2) = 0,
        @Other DECIMAL(18,2) = 0,
        @TotalBeforeTax DECIMAL(18,2) = 0,
        @TaxTotal DECIMAL(18,2) = 0,
        @GrandTotal DECIMAL(18,2) = 0;

    ---------------------------------------------------
    -- Calculate totals by category
    ---------------------------------------------------
    SELECT 
        @Parts = SUM(CASE WHEN ItemType = 'Part' THEN (Quantity * UnitPrice) ELSE 0 END),
        @Labour = SUM(CASE WHEN ItemType = 'Labour' THEN (Quantity * UnitPrice) ELSE 0 END),
        @Other = SUM(CASE WHEN ItemType = 'Other' THEN (Quantity * UnitPrice) ELSE 0 END),
        @TotalBeforeTax = SUM(Quantity * UnitPrice),
        @TaxTotal = SUM((Quantity * UnitPrice) * (TaxPercent / 100.0))
    FROM EstimateItems
    WHERE EstimateID = @EstimateID
      AND BranchID = @BranchID;

    SET @GrandTotal = @TotalBeforeTax + @TaxTotal;

    ---------------------------------------------------
    -- Update Estimate master table
    ---------------------------------------------------
    UPDATE Estimates
    SET
        TotalPartsCost = ISNULL(@Parts,0),
        TotalLabourCost = ISNULL(@Labour,0),
        TotalOtherCost = ISNULL(@Other,0),
        TotalAmountBeforeTax = ISNULL(@TotalBeforeTax,0),
        TotalTaxAmount = ISNULL(@TaxTotal,0),
        TotalAmountAfterTax = ISNULL(@GrandTotal,0),
        UpdatedDate = GETDATE()
    WHERE EstimateID = @EstimateID
      AND BranchID = @BranchID;

    SELECT 'Totals Recalculated' AS Status;
END;

GO
