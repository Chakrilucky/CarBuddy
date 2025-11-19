SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_List]
(
    @InsuranceClaimID INT,
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
        UpdatedDate
    FROM InsuranceClaimEstimateItems
    WHERE InsuranceClaimID = @InsuranceClaimID
      AND BranchID = @BranchID;
END;

GO
