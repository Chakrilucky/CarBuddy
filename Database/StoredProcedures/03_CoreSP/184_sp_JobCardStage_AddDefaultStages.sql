SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardStage_AddDefaultStages]
    @JobCardID INT,
    @BranchID INT,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------
    -- Default stages (You can modify the sequence)
    -------------------------------------------------------
    DECLARE @Stages TABLE (StageOrder INT, StageName VARCHAR(100));

    INSERT INTO @Stages VALUES
    (1, 'Initial Inspection'),
    (2, 'Mechanical Check'),
    (3, 'Denting Work'),
    (4, 'Painting Work'),
    (5, 'QC Inspection'),
    (6, 'Final Washing'),
    (7, 'Ready for Delivery');

    -------------------------------------------------------
    -- Insert stages for the job card
    -------------------------------------------------------
    INSERT INTO JobCardStages
    (
        JobCardId, StageOrder, StageName,
        Status, UpdatedOn, UpdatedBy, BranchID
    )
    SELECT
        @JobCardID, StageOrder, StageName,
        'Pending', NULL, @CreatedBy, @BranchID
    FROM @Stages;

    SELECT 'Default Stages Added' AS Result;
END;

GO
