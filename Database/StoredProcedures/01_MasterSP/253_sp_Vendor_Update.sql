SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vendor_Update]
(
    @VendorID INT,
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
    @IsActive BIT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Vendors
    SET
        VendorName = @VendorName,
        ContactPerson = @ContactPerson,
        MobileNumber = @MobileNumber,
        AlternateMobile = @AlternateMobile,
        Email = @Email,
        AddressLine1 = @AddressLine1,
        AddressLine2 = @AddressLine2,
        City = @City,
        State = @State,
        Pincode = @Pincode,
        GSTNumber = @GSTNumber,
        PANNumber = @PANNumber,
        PaymentTerms = @PaymentTerms,
        Notes = @Notes,
        IsActive = @IsActive,
        UpdatedDate = GETDATE()
    WHERE VendorID = @VendorID
      AND BranchID = @BranchID;
END;

GO
