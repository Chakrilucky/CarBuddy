SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FullBodyPainting_AutoSelectPanels]
    @JobCardID INT,
    @BodyTypeID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PanelID INT;

    DECLARE PanelCursor CURSOR FOR
        SELECT PanelID 
        FROM PanelMaster
        WHERE IsActive = 1 AND BranchID = @BranchID;

    OPEN PanelCursor;

    FETCH NEXT FROM PanelCursor INTO @PanelID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -------------------------------------------------------
        -- Skip if already added
        -------------------------------------------------------
        IF NOT EXISTS (
            SELECT 1 FROM JobCardPanels
            WHERE JobCardID = @JobCardID
              AND PanelID = @PanelID
              AND BranchID = @BranchID
        )
        BEGIN
            -------------------------------------------------------
            -- Fetch Pricing for this Panel
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

            -------------------------------------------------------
            -- Insert Panel if pricing is available
            -------------------------------------------------------
            IF @PaintingCost IS NOT NULL
            BEGIN
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
            END
        END

        FETCH NEXT FROM PanelCursor INTO @PanelID;
    END

    CLOSE PanelCursor;
    DEALLOCATE PanelCursor;

    SELECT 'Full Body Painting Panels Added' AS Status;
END;

GO
