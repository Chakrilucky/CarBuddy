SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobStages_Add]
    @JobCardID INT,
    @StageOrder INT,
    @StageName VARCHAR(100),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobCardStages
    (
        JobCardId, StageOrder, StageName,
        Status, UpdatedOn, BranchID
    )
    VALUES
    (
        @JobCardID, @StageOrder, @StageName,
        'Pending', NULL, @BranchID
    );

    SELECT SCOPE_IDENTITY() AS JobCardStageID;
END;

GO
