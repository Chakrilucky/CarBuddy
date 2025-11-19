SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimApproval_Delete]
(
    @ClaimApprovalID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM InsuranceClaimApprovals
    WHERE 
        ClaimApprovalID = @ClaimApprovalID
        AND BranchID = @BranchID;

    SELECT 'Deleted Successfully' AS Result;
END;

GO
