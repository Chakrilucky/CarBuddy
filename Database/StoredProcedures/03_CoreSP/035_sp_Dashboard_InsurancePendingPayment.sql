SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InsurancePendingPayment]
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
        lastApproval.ApprovedAmount,
        ISNULL(totalPaid.TotalPaid, 0) AS TotalPaid,
        (ISNULL(lastApproval.ApprovedAmount, 0) - ISNULL(totalPaid.TotalPaid, 0)) AS PendingAmount,
        lastApproval.ApprovalDate
    FROM InsuranceClaims ic
        INNER JOIN JobCards jc ON ic.JobCardID = jc.JobCardID
        INNER JOIN Customers c ON jc.CustomerID = c.CustomerID
        INNER JOIN Vehicles v ON jc.VehicleID = v.VehicleID

        OUTER APPLY (
            SELECT TOP 1 ApprovedAmount, ApprovalDate
            FROM InsuranceClaimApprovals a
            WHERE a.InsuranceClaimID = ic.InsuranceClaimID
            ORDER BY a.ApprovalDate DESC
        ) lastApproval

        OUTER APPLY (
            SELECT SUM(AmountPaid) AS TotalPaid
            FROM InsuranceClaimPayments p
            WHERE p.InsuranceClaimID = ic.InsuranceClaimID
        ) totalPaid

    WHERE 
        jc.BranchID = @BranchID
        AND lastApproval.ApprovedAmount IS NOT NULL
        AND (ISNULL(totalPaid.TotalPaid, 0) < ISNULL(lastApproval.ApprovedAmount, 0))

    ORDER BY ic.InsuranceClaimID DESC;

END;

GO
