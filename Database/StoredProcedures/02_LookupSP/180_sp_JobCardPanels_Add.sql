SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardPanels_Add]
    @JobCardID INT,
    @PanelID INT,
    @BodyTypeID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------
    -- Prevent duplicate panel entry
    -------------------------------------------------------
    IF EXISTS (
        SELECT 1 
        FROM JobCardPanels
        WHERE JobCardID = @JobCardID
          AND PanelID = @PanelID
          AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR ('This panel is already added for this job card.', 16, 1);
        RETURN;
    END

    -------------------------------------------------------
    -- Fetch Panel Pricing
    -------------------------------------------------------
    DECLARE @DentingCost DECIMAL(18,2),
            @PaintingCost DECIMAL(18,2);

    SELECT 
        @DentingCost = DentingCost,
        @PaintingCost = PaintingCost
    FROM PanelPricing
    WHERE PanelID = @PanelID
      AND BodyTypeID = @BodyTypeID
      AND BranchID = @BranchID;

    IF @DentingCost IS NULL
    BEGIN
        RAISERROR ('Pricing not found for the selected panel & body type.', 16, 1);
        RETURN;
    END

    -------------------------------------------------------
    -- Insert Panel into JobCard
    -------------------------------------------------------
    INSERT INTO JobCardPanels
    (
        JobCardID, PanelID, BodyTypeID,
        DentingCost, PaintingCost,
        CreatedDate, BranchID
    )
    VALUES
    (
        @JobCardID, @PanelID, @BodyTypeID,
        @DentingCost, @PaintingCost,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS JobCardPanelID;
END;

GO
