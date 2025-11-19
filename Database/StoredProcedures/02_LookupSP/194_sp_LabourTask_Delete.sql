SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTask_Delete]
(
    @LabourTaskID INT,
    @BranchID INT
)
AS
BEGIN
    UPDATE LabourTasks
    SET IsActive = 0,
        UpdatedDate = GETDATE()
    WHERE LabourTaskID = @LabourTaskID
      AND BranchID = @BranchID;
END;

GO
