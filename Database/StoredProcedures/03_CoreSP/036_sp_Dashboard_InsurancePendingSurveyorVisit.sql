SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InsurancePendingSurveyorVisit]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ic.InsuranceClaimID,
        jc.JobCardID,
        jc.JobCardNumber,
        c.FullName AS CustomerName,
        v.RegistrationNumber,
        ic.ClaimNumber,
        ic.ClaimType,
        ISNULL(lastVisit.VisitStatus, 'Pending') AS VisitStatus,
        lastVisit.VisitDate AS LastVisitDate
    FROM InsuranceClaims ic
        INNER JOIN JobCards jc ON ic.JobCardID = jc.JobCardID
        INNER JOIN Customers c ON jc.CustomerID = c.CustomerID
        INNER JOIN Vehicles v ON jc.VehicleID = v.VehicleID

        OUTER APPLY (
            SELECT TOP 1 VisitStatus, VisitDate
            FROM InsuranceSurveyorVisits sv
            WHERE sv.InsuranceClaimID = ic.InsuranceClaimID
            ORDER BY sv.VisitDate DESC
        ) lastVisit

    WHERE 
        jc.BranchID = @BranchID
        AND (
                lastVisit.VisitStatus IS NULL
                OR lastVisit.VisitStatus = 'Pending'
            )

    ORDER BY ic.InsuranceClaimID DESC;

END;

GO
