SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimApproval_List]
    @InsuranceClaimID INT,
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
    FROM 
        InsuranceClaimApprovals A
    WHERE 
        A.InsuranceClaimID = @InsuranceClaimID
        AND A.BranchID = @BranchID
    ORDER BY 
        A.ClaimApprovalID DESC;
END;

GO
