SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_Delete]
(
    @ClaimEstimateItemID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete only if record belongs to same branch
    DELETE FROM InsuranceClaimEstimateItems
    WHERE 
        ClaimEstimateItemID = @ClaimEstimateItemID
        AND BranchID = @BranchID;

    SELECT 
        'Estimate Item deleted successfully.' AS Message;
END;

GO
