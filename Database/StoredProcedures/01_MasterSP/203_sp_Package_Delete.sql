SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_Delete]
(
    @PackageID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Packages
    SET IsActive = 0,
        UpdatedDate = GETDATE()
    WHERE PackageID = @PackageID
      AND BranchID = @BranchID;
END;

GO
