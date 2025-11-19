SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTask_GetByID]
(
    @LabourTaskID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM LabourTasks
    WHERE LabourTaskID = @LabourTaskID
      AND BranchID = @BranchID;
END;

GO
