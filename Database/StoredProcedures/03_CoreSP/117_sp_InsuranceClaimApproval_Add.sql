SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimApproval_Add]
    @InsuranceClaimID INT,
    @ApprovalType VARCHAR(50),       -- e.g. Full / Partial / Reject
    @ApprovedAmount DECIMAL(18,2) = NULL,
    @RejectedReason NVARCHAR(200) = NULL,
    @ApprovedBy NVARCHAR(100),
    @ApprovalDate DATETIME2,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaimApprovals
    (
        InsuranceClaimID,
        ApprovalType,
        ApprovedAmount,
        RejectedReason,
        ApprovedBy,
        ApprovalDate,
        Notes,
        CreatedDate,
        UpdatedDate,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        @ApprovalType,
        @ApprovedAmount,
        @RejectedReason,
        @ApprovedBy,
        @ApprovalDate,
        @Notes,
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewApprovalID;
END;

GO
