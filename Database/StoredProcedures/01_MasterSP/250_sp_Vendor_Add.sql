SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vendor_Add]
(
    @VendorName NVARCHAR(200),
    @ContactPerson NVARCHAR(200) = NULL,
    @MobileNumber VARCHAR(20) = NULL,
    @AlternateMobile VARCHAR(20) = NULL,
    @Email NVARCHAR(200) = NULL,
    @AddressLine1 NVARCHAR(300) = NULL,
    @AddressLine2 NVARCHAR(300) = NULL,
    @City NVARCHAR(100) = NULL,
    @State NVARCHAR(100) = NULL,
    @Pincode VARCHAR(20) = NULL,
    @GSTNumber NVARCHAR(50) = NULL,
    @PANNumber NVARCHAR(50) = NULL,
    @PaymentTerms NVARCHAR(200) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Vendors
    (
        VendorName,
        ContactPerson,
        MobileNumber,
        AlternateMobile,
        Email,
        AddressLine1,
        AddressLine2,
        City,
        State,
        Pincode,
        GSTNumber,
        PANNumber,
        PaymentTerms,
        Notes,
        IsActive,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @VendorName,
        @ContactPerson,
        @MobileNumber,
        @AlternateMobile,
        @Email,
        @AddressLine1,
        @AddressLine2,
        @City,
        @State,
        @Pincode,
        @GSTNumber,
        @PANNumber,
        @PaymentTerms,
        @Notes,
        1,              -- Default Active
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VendorID;
END;

GO
