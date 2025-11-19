SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimApproval_Get]
    @ClaimApprovalID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        A.ClaimApprovalID,
        A.InsuranceClaimID,
        A.ApprovalType,
        A.ApprovedAmount,
        A.RejectedReason,
        A.ApprovedBy,
        A.ApprovalDate,
        A.Notes,
        A.CreatedDate,
        A.UpdatedDate
    FROM InsuranceClaimApprovals A
    WHERE 
        A.ClaimApprovalID = @ClaimApprovalID
        AND A.BranchID = @BranchID;
END;

GO
