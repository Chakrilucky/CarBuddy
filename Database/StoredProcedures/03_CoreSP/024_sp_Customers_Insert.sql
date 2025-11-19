SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customers_Insert]
    @FullName NVARCHAR(150),
    @MobileNumber VARCHAR(15),
    @AlternateMobile VARCHAR(15),
    @Email NVARCHAR(150),
    @AddressLine1 NVARCHAR(200),
    @AddressLine2 NVARCHAR(200),
    @City NVARCHAR(100),
    @State NVARCHAR(100),
    @Pincode VARCHAR(10),
    @GSTNumber VARCHAR(20),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate mobile check
    IF EXISTS (SELECT 1 FROM Customers WHERE MobileNumber = @MobileNumber AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Customer mobile number already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Customers
    (
        FullName, MobileNumber, AlternateMobile, Email, AddressLine1,
        AddressLine2, City, State, Pincode, GSTNumber,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @FullName, @MobileNumber, @AlternateMobile, @Email, @AddressLine1,
        @AddressLine2, @City, @State, @Pincode, @GSTNumber,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS CustomerID;
END;

GO
