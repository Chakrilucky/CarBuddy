SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PendingInsuranceClaims]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        IC.InsuranceClaimID,
        IC.JobCardID,
        IC.ClaimNumber,
        IC.ClaimType,
        IC.ClaimStatus,
        IC.CreatedDate AS ClaimCreatedDate,
        IC.SurveyorName,
        IC.SurveyorMobile,
        IC.SurveyorVisitDate,
        JC.JobCardNumber,
        C.FullName AS CustomerName,
        C.MobileNumber,
        V.RegistrationNumber,
        ICo.CompanyName AS InsuranceCompany,
        IC.EstimateAmount,
        IC.ApprovedAmount,
        IC.RejectedReason
    FROM InsuranceClaims IC
    INNER JOIN JobCards JC ON IC.JobCardID = JC.JobCardID
    INNER JOIN Customers C ON JC.CustomerID = C.CustomerID
    INNER JOIN Vehicles V ON JC.VehicleID = V.VehicleID
    INNER JOIN InsuranceCompanies ICo ON IC.InsuranceCompanyID = ICo.InsuranceCompanyID
    WHERE 
        IC.ClaimStatus NOT IN ('Approved', 'Rejected', 'Closed')
        AND IC.BranchID = @BranchID
    ORDER BY 
        IC.CreatedDate DESC;
END;

GO
