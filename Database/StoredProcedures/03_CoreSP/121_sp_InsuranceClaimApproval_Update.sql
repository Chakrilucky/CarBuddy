SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimApproval_Update]
    @ClaimApprovalID INT,
    @ApprovalType VARCHAR(50),
    @ApprovedAmount DECIMAL(18,2) = NULL,
    @RejectedReason NVARCHAR(500) = NULL,
    @ApprovedBy NVARCHAR(200),
    @ApprovalDate DATETIME2,
    @Notes NVARCHAR(500) = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InsuranceClaimApprovals
    SET 
        ApprovalType = @ApprovalType,
        ApprovedAmount = @ApprovedAmount,
        RejectedReason = @RejectedReason,
        ApprovedBy = @ApprovedBy,
        ApprovalDate = @ApprovalDate,
        Notes = @Notes,
        UpdatedDate = GETDATE()
    WHERE 
        ClaimApprovalID = @ClaimApprovalID
        AND BranchID = @BranchID;
END;

GO
