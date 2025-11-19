SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VehicleBodyTypes_Insert]
    @BodyTypeName NVARCHAR(50),
    @Description NVARCHAR(200),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM VehicleBodyTypes 
               WHERE BodyTypeName = @BodyTypeName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Body type already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO VehicleBodyTypes
    (
        BodyTypeName, Description, IsActive,
        CreatedDate, BranchID
    )
    VALUES
    (
        @BodyTypeName, @Description, 1,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS BodyTypeID;
END;

GO
