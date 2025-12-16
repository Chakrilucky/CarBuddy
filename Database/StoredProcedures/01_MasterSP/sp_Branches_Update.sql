SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Branches_Update
    @BranchID INT,
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

    UPDATE Branches
    SET
        BranchName   = @BranchName,
        City         = @City,
        State        = @State,
        AddressLine1 = @AddressLine1,
        AddressLine2 = @AddressLine2,
        Pincode      = @Pincode,
        PhoneNumber  = @PhoneNumber,
        Email        = @Email
    WHERE BranchID = @BranchID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
