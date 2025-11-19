SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ServiceTypes_Insert]
    @ServiceName NVARCHAR(150),
    @Category NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate check per branch
    IF EXISTS (SELECT 1 FROM ServiceTypes 
               WHERE ServiceName = @ServiceName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Service name already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO ServiceTypes
    (
        ServiceName, Category, Description,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @ServiceName, @Category, @Description,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS ServiceTypeID;
END;

GO
