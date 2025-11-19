SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PackageItem_List]
    @PackageID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PI.PackageItemID,
        PI.PackageID,
        PI.ItemType,
        PI.ItemName,
        PI.Quantity,
        PI.UnitPrice,
        PI.TotalPrice,
        PI.BranchID
    FROM PackageItems PI
    WHERE 
        PI.PackageID = @PackageID
        AND PI.BranchID = @BranchID
    ORDER BY 
        PI.ItemName;
END;

GO
