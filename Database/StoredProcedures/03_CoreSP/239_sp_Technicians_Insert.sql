SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Technicians_Insert]
    @UserID INT,
    @TechnicianName NVARCHAR(150),
    @MobileNumber VARCHAR(15),
    @SkillLevel VARCHAR(50),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Technicians
    (
        UserID, TechnicianName, MobileNumber, SkillLevel,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @UserID, @TechnicianName, @MobileNumber, @SkillLevel,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS TechnicianID;
END;

GO
