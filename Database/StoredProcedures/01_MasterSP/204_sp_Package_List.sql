SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_List]
(
    @BranchID INT,
    @ServiceTypeID INT = NULL,
    @IsActiveOnly BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.PackageID,
        P.ServiceTypeID,
        ST.ServiceName AS ServiceTypeName,
        P.PackageName,
        P.PackagePrice,
        P.Description,
        P.IsActive,
        P.CreatedDate,
        P.UpdatedDate
    FROM Packages P
    LEFT JOIN ServiceTypes ST ON P.ServiceTypeID = ST.ServiceTypeID
    WHERE P.BranchID = @BranchID
      AND (@ServiceTypeID IS NULL OR P.ServiceTypeID = @ServiceTypeID)
      AND (@IsActiveOnly = 0 OR P.IsActive = 1)
    ORDER BY P.PackageName;
END;

GO
