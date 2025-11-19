SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_QCChecklistItems_Insert]
    @ChecklistID INT,
    @ItemName NVARCHAR(300),
    @ItemDescription NVARCHAR(MAX),
    @IsMandatory BIT,
    @DisplayOrder INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO QCChecklistItems
    (
        ChecklistID, ItemName, ItemDescription,
        IsMandatory, DisplayOrder, CreatedDate, BranchID
    )
    VALUES
    (
        @ChecklistID, @ItemName, @ItemDescription,
        @IsMandatory, @DisplayOrder, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS QCItemID;
END;

GO
