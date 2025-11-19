SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PanelMaster_Insert]
    @PanelName NVARCHAR(150),
    @Description NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM PanelMaster 
               WHERE PanelName = @PanelName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Panel name already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO PanelMaster
    (
        PanelName, Description, IsActive,
        CreatedDate, BranchID
    )
    VALUES
    (
        @PanelName, @Description, 1,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PanelID;
END;

GO
