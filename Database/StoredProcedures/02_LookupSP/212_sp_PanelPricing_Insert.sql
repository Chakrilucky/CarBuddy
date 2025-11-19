SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PanelPricing_Insert]
    @PanelID INT,
    @BodyTypeID INT,
    @DentingCost DECIMAL(18,2),
    @PaintingCost DECIMAL(18,2),
    @IsFullBodyApplicable BIT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM PanelPricing 
               WHERE PanelID = @PanelID 
                 AND BodyTypeID = @BodyTypeID 
                 AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Pricing already exists for this panel and body type.', 16, 1);
        RETURN;
    END

    INSERT INTO PanelPricing
    (
        PanelID, BodyTypeID, DentingCost, PaintingCost,
        IsFullBodyApplicable, CreatedDate, BranchID
    )
    VALUES
    (
        @PanelID, @BodyTypeID, @DentingCost, @PaintingCost,
        @IsFullBodyApplicable, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PricingID;
END;

GO
