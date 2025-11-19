SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vendors_Insert]
    @VendorName NVARCHAR(200),
    @ContactPerson NVARCHAR(150),
    @MobileNumber VARCHAR(15),
    @AlternateMobile VARCHAR(15),
    @Email NVARCHAR(150),
    @AddressLine1 NVARCHAR(200),
    @AddressLine2 NVARCHAR(200),
    @City NVARCHAR(100),
    @State NVARCHAR(100),
    @Pincode VARCHAR(10),
    @GSTNumber NVARCHAR(20),
    @PANNumber NVARCHAR(20),
    @PaymentTerms NVARCHAR(150),
    @Notes NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Vendors 
               WHERE VendorName = @VendorName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Vendor already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Vendors
    (
        VendorName, ContactPerson, MobileNumber, AlternateMobile,
        Email, AddressLine1, AddressLine2, City, State, Pincode,
        GSTNumber, PANNumber, PaymentTerms, Notes,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @VendorName, @ContactPerson, @MobileNumber, @AlternateMobile,
        @Email, @AddressLine1, @AddressLine2, @City, @State, @Pincode,
        @GSTNumber, @PANNumber, @PaymentTerms, @Notes,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VendorID;
END;

GO
