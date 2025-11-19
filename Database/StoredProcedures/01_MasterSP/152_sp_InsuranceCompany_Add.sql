SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceCompany_Add]
(
    @CompanyName      NVARCHAR(100),
    @ContactPerson    NVARCHAR(100),
    @MobileNumber     VARCHAR(20),
    @Email            NVARCHAR(150),
    @AddressLine1     NVARCHAR(200),
    @AddressLine2     NVARCHAR(200),
    @City             NVARCHAR(100),
    @State            NVARCHAR(100),
    @Pincode          VARCHAR(10),
    @GSTNumber        NVARCHAR(50),
    @Notes            NVARCHAR(MAX),
    @BranchID         INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceCompanies
    (
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
        UpdatedDate,
        BranchID
    )
    VALUES
    (
        @CompanyName,
        @ContactPerson,
        @MobileNumber,
        @Email,
        @AddressLine1,
        @AddressLine2,
        @City,
        @State,
        @Pincode,
        @GSTNumber,
        @Notes,
        1,                  -- IsActive
        GETDATE(),          -- CreatedDate
        GETDATE(),          -- UpdatedDate
        @BranchID
    );
END;

GO
