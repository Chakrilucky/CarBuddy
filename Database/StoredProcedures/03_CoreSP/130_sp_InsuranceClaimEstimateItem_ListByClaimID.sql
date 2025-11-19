SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_ListByClaimID]
(
    @InsuranceClaimID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CEI.ClaimEstimateItemID,
        CEI.InsuranceClaimID,
        CEI.ItemType,
        CEI.ItemName,
        CEI.ItemDescription,
        CEI.Quantity,
        CEI.RequestedUnitPrice,
        CEI.RequestedTotalPrice,
        CEI.IsApproved,
        CEI.ApprovedUnitPrice,
        CEI.ApprovedTotalPrice,
        CEI.SurveyorRemarks,
        CEI.CreatedDate,
        CEI.UpdatedDate
    FROM 
        InsuranceClaimEstimateItems CEI
    WHERE 
        CEI.InsuranceClaimID = @InsuranceClaimID
        AND CEI.BranchID = @BranchID
    ORDER BY 
        CEI.ClaimEstimateItemID DESC;
END;

GO
