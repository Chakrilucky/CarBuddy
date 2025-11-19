SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimate_UpdateTotals]
(
    @InsuranceClaimID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Get total requested amount (computed column: RequestedTotalPrice)
    DECLARE @TotalRequested DECIMAL(18,2) = (
        SELECT SUM(RequestedTotalPrice)
        FROM InsuranceClaimEstimateItems
        WHERE InsuranceClaimID = @InsuranceClaimID
          AND BranchID = @BranchID
    );

    -- Get total approved amount (computed column: ApprovedTotalPrice)
    DECLARE @TotalApproved DECIMAL(18,2) = (
        SELECT SUM(ApprovedTotalPrice)
        FROM InsuranceClaimEstimateItems
        WHERE InsuranceClaimID = @InsuranceClaimID
          AND BranchID = @BranchID
    );

    -- Protect against NULL values
    SET @TotalRequested = ISNULL(@TotalRequested, 0);
    SET @TotalApproved = ISNULL(@TotalApproved, 0);

    -- Update main claim table
    UPDATE InsuranceClaims
    SET 
        EstimateAmount = @TotalRequested,
        ApprovedAmount = @TotalApproved,
        UpdatedDate = GETDATE()
    WHERE InsuranceClaimID = @InsuranceClaimID
      AND BranchID = @BranchID;

    SELECT 
        @TotalRequested AS TotalRequested,
        @TotalApproved AS TotalApproved;
END;

GO
