SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardPanels_UpdateCost]
    @JobCardPanelID INT,
    @DentingCost DECIMAL(18,2),
    @PaintingCost DECIMAL(18,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobCardPanels
    SET 
        DentingCost = @DentingCost,
        PaintingCost = @PaintingCost
    WHERE JobCardPanelID = @JobCardPanelID
      AND BranchID = @BranchID;

    SELECT 'Updated' AS Status;
END;

GO
