SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardStage_Reopen]
    @JobCardStageID BIGINT,
    @UpdatedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobCardStages
    SET 
        Status = 'InProgress',
        UpdatedOn = GETDATE(),
        UpdatedBy = @UpdatedBy
    WHERE JobCardStageId = @JobCardStageID
      AND BranchID = @BranchID;

    SELECT 'Stage Reopened' AS Result;
END;

GO
