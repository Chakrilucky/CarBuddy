SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobStages_UpdateStatus]
    @JobCardStageID BIGINT,
    @Status VARCHAR(50),
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobCardStages
    SET 
        Status = @Status,
        UpdatedOn = GETDATE(),
        UpdatedBy = @UpdatedBy
    WHERE JobCardStageId = @JobCardStageID;
END;

GO
