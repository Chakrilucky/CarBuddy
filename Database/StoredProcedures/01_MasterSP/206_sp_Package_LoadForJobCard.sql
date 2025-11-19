SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_LoadForJobCard]
(
    @PackageID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------
    -- 1️⃣ Load Package Header
    -------------------------------
    SELECT 
        P.PackageID,
        P.PackageName,
        P.PackagePrice,
        P.Description,
        ST.ServiceName AS ServiceTypeName
    FROM Packages P
    LEFT JOIN ServiceTypes ST ON P.ServiceTypeID = ST.ServiceTypeID
    WHERE P.PackageID = @PackageID
      AND P.BranchID = @BranchID;

    -------------------------------
    -- 2️⃣ Load Items (Labour + Parts)
    -------------------------------
    SELECT
        PI.PackageItemID,
        PI.PackageID,
        PI.ItemType,          -- Labour / Part
        PI.ItemName,
        PI.Quantity,
        PI.UnitPrice,
        PI.TotalPrice
    FROM PackageItems PI
    WHERE PI.PackageID = @PackageID
      AND PI.BranchID = @BranchID
    ORDER BY PI.ItemType, PI.ItemName;

END;

GO
