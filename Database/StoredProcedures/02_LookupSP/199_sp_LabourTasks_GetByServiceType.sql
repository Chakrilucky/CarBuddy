SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTasks_GetByServiceType]
(
    @ServiceTypeID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LabourTaskID,
        ServiceTypeID,
        TaskName,
        DefaultHours,
        DefaultRate,
        Description
    FROM LabourTasks
    WHERE ServiceTypeID = @ServiceTypeID
      AND BranchID = @BranchID
      AND IsActive = 1
    ORDER BY TaskName;
END;

GO
