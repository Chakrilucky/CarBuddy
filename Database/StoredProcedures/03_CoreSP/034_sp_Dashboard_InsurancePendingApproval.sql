SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InsurancePendingApproval]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ic.InsuranceClaimID,
        ic.ClaimNumber,
        ic.ClaimType,
        jc.JobCardID,
        jc.JobCardNumber,
        c.FullName AS CustomerName,
        v.RegistrationNumber,
        ic.ClaimStatus,
        lastApproval.ApprovalType,
        lastApproval.ApprovalDate,
        lastApproval.ApprovedAmount
    FROM InsuranceClaims ic
        INNER JOIN JobCards jc ON ic.JobCardID = jc.JobCardID
        INNER JOIN Customers c ON jc.CustomerID = c.CustomerID
        INNER JOIN Vehicles v ON jc.VehicleID = v.VehicleID

        OUTER APPLY (
            SELECT TOP 1 ApprovalType, ApprovalDate, ApprovedAmount
            FROM InsuranceClaimApprovals a
            WHERE a.InsuranceClaimID = ic.InsuranceClaimID
            ORDER BY a.ApprovalDate DESC
        ) lastApproval

    WHERE 
        jc.BranchID = @BranchID
        AND (
                ic.ClaimStatus IN ('Initiated', 'SurveyCompleted', 'EstimateSubmitted', 'ApprovalPending')
                OR lastApproval.ApprovalType IS NULL
            )

    ORDER BY ic.InsuranceClaimID DESC;

END;

GO
