SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsurancePolicy_Add]
(
    @InsuranceCompanyID INT,
    @PolicyNumber       NVARCHAR(100),
    @CustomerID         INT,
    @VehicleID          INT,
    @PolicyType         VARCHAR(50),
    @StartDate          DATETIME2,
    @EndDate            DATETIME2,
    @PremiumAmount      DECIMAL(18,2),
    @Notes              NVARCHAR(MAX),
    @BranchID           INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsurancePolicies
    (
        InsuranceCompanyID, PolicyNumber, CustomerID, VehicleID,
        PolicyType, StartDate, EndDate, PremiumAmount, Notes,
        CreatedDate, BranchID
    )
    VALUES
    (
        @InsuranceCompanyID, @PolicyNumber, @CustomerID, @VehicleID,
        @PolicyType, @StartDate, @EndDate, @PremiumAmount, @Notes,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewPolicyID;
END;

GO
