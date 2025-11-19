SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceCompany_Update]
(
    @InsuranceCompanyID  INT,
    @CompanyName         NVARCHAR(100),
    @ContactPerson       NVARCHAR(100),
    @MobileNumber        VARCHAR(20),
    @Email               NVARCHAR(150),
    @AddressLine1        NVARCHAR(200),
    @AddressLine2        NVARCHAR(200),
    @City                NVARCHAR(100),
    @State               NVARCHAR(100),
    @Pincode             VARCHAR(10),
    @GSTNumber           NVARCHAR(50),
    @Notes               NVARCHAR(MAX),
    @IsActive            BIT,
    @BranchID            INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InsuranceCompanies
    SET
        CompanyName     = @CompanyName,
        ContactPerson   = @ContactPerson,
        MobileNumber    = @MobileNumber,
        Email           = @Email,
        AddressLine1    = @AddressLine1,
        AddressLine2    = @AddressLine2,
        City            = @City,
        State           = @State,
        Pincode         = @Pincode,
        GSTNumber       = @GSTNumber,
        Notes           = @Notes,
        IsActive        = @IsActive,
        UpdatedDate     = GETDATE(),
        BranchID        = @BranchID
    WHERE InsuranceCompanyID = @InsuranceCompanyID;
END;

GO
