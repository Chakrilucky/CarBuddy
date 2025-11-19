SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PriorityTypes_Insert]
    @PriorityName NVARCHAR(50),
    @ExtraCharge DECIMAL(18,2),
    @Description NVARCHAR(300),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM PriorityTypes 
               WHERE PriorityName = @PriorityName AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Priority name already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO PriorityTypes
    (
        PriorityName, ExtraCharge, Description,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @PriorityName, @ExtraCharge, @Description,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PriorityTypeID;
END;

GO
