SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceClaim_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IC.InsuranceClaimID,
        IC.ClaimNumber,
        IC.ClaimType,
        IC.ClaimStatus,
        IC.EstimateAmount,
        IC.ApprovedAmount,
        IC.SurveyorName,
        IC.SurveyorMobile,
        IC.SurveyorVisitDate,
        IC.CreatedDate,
        JC.JobCardNumber,
        C.CustomerID,
        V.RegistrationNumber,
        CO.CompanyName AS InsuranceCompany
    FROM InsuranceClaims IC
    LEFT JOIN JobCards JC ON IC.JobCardID = JC.JobCardID
    LEFT JOIN Customers C ON JC.CustomerID = C.CustomerID
    LEFT JOIN Vehicles V ON JC.VehicleID = V.VehicleID
    LEFT JOIN InsuranceCompanies CO ON IC.InsuranceCompanyID = CO.InsuranceCompanyID
    WHERE IC.BranchID = @BranchID
    ORDER BY IC.InsuranceClaimID DESC;
END;

GO
