SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Part_GetByID]
(
    @PartID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM InventoryParts
    WHERE PartID = @PartID
      AND BranchID = @BranchID;
END;

GO
