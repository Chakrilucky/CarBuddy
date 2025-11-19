SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardStage_UpdateStatus]
    @JobCardStageID BIGINT,
    @NewStatus VARCHAR(50),
    @UpdatedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobCardStages
    SET 
        Status = @NewStatus,
        UpdatedOn = GETDATE(),
        UpdatedBy = @UpdatedBy
    WHERE JobCardStageId = @JobCardStageID
      AND BranchID = @BranchID;

    SELECT 'Stage Updated' AS Status;
END;

GO
