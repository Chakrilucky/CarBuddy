SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceCompany_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        InsuranceCompanyID,
        CompanyName,
        ContactPerson,
        MobileNumber,
        Email,
        AddressLine1,
        AddressLine2,
        City,
        State,
        Pincode,
        GSTNumber,
        Notes,
        IsActive,
        CreatedDate,
        UpdatedDate
    FROM InsuranceCompanies
    WHERE BranchID = @BranchID
    ORDER BY CompanyName;
END;

GO
