SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_Add]
(
    @FullName NVARCHAR(150),
    @MobileNumber VARCHAR(15),
    @AlternateMobile VARCHAR(15) = NULL,
    @Email NVARCHAR(150) = NULL,
    @AddressLine1 NVARCHAR(200) = NULL,
    @AddressLine2 NVARCHAR(200) = NULL,
    @City NVARCHAR(100) = NULL,
    @State NVARCHAR(100) = NULL,
    @Pincode VARCHAR(10) = NULL,
    @GSTNumber VARCHAR(20) = NULL,
    @RCPhotoPath NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Prevent duplicate customer mobile number in same branch
    IF EXISTS (SELECT 1 FROM Customers
               WHERE MobileNumber = @MobileNumber
                 AND BranchID = @BranchID)
    BEGIN
        RAISERROR('A customer with this mobile number already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Customers
    (
        FullName,
        MobileNumber,
        AlternateMobile,
        Email,
        AddressLine1,
        AddressLine2,
        City,
        State,
        Pincode,
        GSTNumber,
        RCPhotoPath,
        IsActive,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @FullName,
        @MobileNumber,
        @AlternateMobile,
        @Email,
        @AddressLine1,
        @AddressLine2,
        @City,
        @State,
        @Pincode,
        @GSTNumber,
        @RCPhotoPath,
        1,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS CustomerID;
END;

GO
