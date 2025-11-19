SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsurancePolicy_Update]
(
    @PolicyID           INT,
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

    UPDATE InsurancePolicies
    SET
        InsuranceCompanyID = @InsuranceCompanyID,
        PolicyNumber       = @PolicyNumber,
        CustomerID         = @CustomerID,
        VehicleID          = @VehicleID,
        PolicyType         = @PolicyType,
        StartDate          = @StartDate,
        EndDate            = @EndDate,
        PremiumAmount      = @PremiumAmount,
        Notes              = @Notes,
        UpdatedDate        = GETDATE(),
        BranchID           = @BranchID
    WHERE PolicyID = @PolicyID;
END;

GO
