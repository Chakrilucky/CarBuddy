SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_Update]
(
    @CustomerID INT,
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

    IF NOT EXISTS (SELECT 1 FROM Customers 
                   WHERE CustomerID = @CustomerID
                     AND BranchID = @BranchID)
    BEGIN
        RAISERROR('Invalid CustomerID for this branch.', 16, 1);
        RETURN;
    END

    UPDATE Customers
    SET
        FullName = @FullName,
        MobileNumber = @MobileNumber,
        AlternateMobile = @AlternateMobile,
        Email = @Email,
        AddressLine1 = @AddressLine1,
        AddressLine2 = @AddressLine2,
        City = @City,
        State = @State,
        Pincode = @Pincode,
        GSTNumber = @GSTNumber,
        RCPhotoPath = @RCPhotoPath,
        UpdatedDate = GETDATE()
    WHERE 
        CustomerID = @CustomerID
        AND BranchID = @BranchID;
END;

GO
