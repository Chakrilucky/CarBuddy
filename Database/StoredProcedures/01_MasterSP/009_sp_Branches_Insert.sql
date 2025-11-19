SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Branches_Insert]
    @BranchName NVARCHAR(200),
    @City NVARCHAR(100),
    @State NVARCHAR(100),
    @AddressLine1 NVARCHAR(200),
    @AddressLine2 NVARCHAR(200),
    @Pincode NVARCHAR(20),
    @PhoneNumber NVARCHAR(20),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Branches
    (
        BranchName, City, State, AddressLine1, AddressLine2,
        Pincode, PhoneNumber, Email, CreatedDate
    )
    VALUES
    (
        @BranchName, @City, @State, @AddressLine1, @AddressLine2,
        @Pincode, @PhoneNumber, @Email, GETDATE()
    );

    SELECT SCOPE_IDENTITY() AS BranchID;
END;

GO
