SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PackageItem_Delete]
(
    @PackageItemID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM PackageItems
    WHERE PackageItemID = @PackageItemID
      AND BranchID = @BranchID;
END;

GO
