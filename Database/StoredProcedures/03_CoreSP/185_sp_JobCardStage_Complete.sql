SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardStage_Complete]
    @JobCardID INT,
    @StageOrder INT,
    @UpdatedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------
    -- 1) Mark current stage as completed
    -------------------------------------------------------
    UPDATE JobCardStages
    SET 
        Status = 'Completed',
        UpdatedOn = GETDATE(),
        UpdatedBy = @UpdatedBy
    WHERE JobCardId = @JobCardID
      AND StageOrder = @StageOrder
      AND BranchID = @BranchID;

    -------------------------------------------------------
    -- 2) Set next stage to InProgress
    -------------------------------------------------------
    UPDATE JobCardStages
    SET 
        Status = 'InProgress',
        UpdatedOn = GETDATE(),
        UpdatedBy = @UpdatedBy
    WHERE JobCardId = @JobCardID
      AND StageOrder = @StageOrder + 1
      AND Status = 'Pending'
      AND BranchID = @BranchID;

    -------------------------------------------------------
    -- 3) Auto update job card status
    -------------------------------------------------------
    EXEC sp_JobCard_AutoUpdateStatus @JobCardID, @BranchID;

    SELECT 'Stage Progressed' AS Result;
END;

GO
