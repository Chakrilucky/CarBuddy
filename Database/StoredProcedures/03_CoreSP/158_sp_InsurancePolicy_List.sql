SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsurancePolicy_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.PolicyID,
        P.PolicyNumber,
        P.PolicyType,
        P.StartDate,
        P.EndDate,
        P.PremiumAmount,
        IC.CompanyName,
        C.CustomerID,
        V.VehicleID,
        P.CreatedDate,
        P.UpdatedDate
    FROM InsurancePolicies P
    LEFT JOIN InsuranceCompanies IC ON P.InsuranceCompanyID = IC.InsuranceCompanyID
    LEFT JOIN Customers C ON P.CustomerID = C.CustomerID
    LEFT JOIN Vehicles V ON P.VehicleID = V.VehicleID
    WHERE P.BranchID = @BranchID
    ORDER BY P.PolicyID DESC;
END;

GO
