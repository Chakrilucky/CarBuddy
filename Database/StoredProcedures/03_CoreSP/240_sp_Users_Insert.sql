SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Users_Insert]
    @FullName NVARCHAR(150),
    @MobileNumber VARCHAR(15),
    @Email VARCHAR(150),
    @Username VARCHAR(50),
    @PasswordHash VARCHAR(200),
    @Role VARCHAR(50),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate Check
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Username already exists', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Users WHERE MobileNumber = @MobileNumber AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Mobile number already exists', 16, 1);
        RETURN;
    END

    INSERT INTO Users
    (
        FullName, MobileNumber, Email, Username, PasswordHash,
        Role, IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @FullName, @MobileNumber, @Email, @Username, @PasswordHash,
        @Role, 1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS UserID;
END;

GO
