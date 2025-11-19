SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_Create]
    @JobCardID INT,
    @CreatedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------
    -- Check if estimate already exists
    ---------------------------------------------------
    IF EXISTS (SELECT 1 FROM Estimates WHERE JobCardID = @JobCardID AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Estimate already exists for this Job Card.', 16, 1);
        RETURN;
    END

    ---------------------------------------------------
    -- Generate Estimate Number
    ---------------------------------------------------
    DECLARE @EstimateNumber VARCHAR(30),
            @Seq INT;

    SET @Seq = (SELECT ISNULL(MAX(EstimateID),0) + 1 FROM Estimates WHERE BranchID = @BranchID);

    SET @EstimateNumber = 'EST-' + CAST(@BranchID AS VARCHAR) + '-' + CAST(@Seq AS VARCHAR);

    ---------------------------------------------------
    -- Insert Estimate
    ---------------------------------------------------
    INSERT INTO Estimates
    (
        JobCardID, EstimateNumber, TotalPartsCost, TotalLabourCost,
        TotalOtherCost, TotalAmountBeforeTax, TotalTaxAmount,
        TotalAmountAfterTax, Status, CreatedBy, CreatedDate, BranchID
    )
    VALUES
    (
        @JobCardID, @EstimateNumber, 0, 0,
        0, 0, 0,
        0, 'Pending', @CreatedBy, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS EstimateID,
           @EstimateNumber AS EstimateNumber;
END;

GO
