SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_Get]
(
    @ClaimEstimateItemID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClaimEstimateItemID,
        InsuranceClaimID,
        ItemType,
        ItemName,
        ItemDescription,
        Quantity,
        RequestedUnitPrice,
        RequestedTotalPrice,   -- computed
        IsApproved,
        ApprovedUnitPrice,
        ApprovedTotalPrice,    -- computed
        SurveyorRemarks,
        CreatedDate,
        UpdatedDate,
        BranchID
    FROM InsuranceClaimEstimateItems
    WHERE 
        ClaimEstimateItemID = @ClaimEstimateItemID
        AND BranchID = @BranchID;
END;

GO
