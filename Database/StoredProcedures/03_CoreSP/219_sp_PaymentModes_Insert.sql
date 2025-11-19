SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PaymentModes_Insert]
    @ModeName VARCHAR(50),
    @ModeCategory VARCHAR(50),
    @Notes NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate check
    IF EXISTS (SELECT 1 FROM PaymentModes 
               WHERE ModeName = @ModeName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Payment mode already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO PaymentModes
    (
        ModeName, ModeCategory, Notes,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @ModeName, @ModeCategory, @Notes,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PaymentModeID;
END;

GO
