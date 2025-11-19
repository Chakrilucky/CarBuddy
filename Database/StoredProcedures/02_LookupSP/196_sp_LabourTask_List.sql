SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTask_List]
(
    @BranchID INT,
    @ServiceTypeID INT = NULL,
    @IsActiveOnly BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LT.LabourTaskID,
        LT.ServiceTypeID,
        ST.ServiceName AS ServiceTypeName,
        LT.TaskName,
        LT.DefaultHours,
        LT.DefaultRate,
        LT.Description,
        LT.IsActive,
        LT.CreatedDate,
        LT.UpdatedDate
    FROM LabourTasks LT
    LEFT JOIN ServiceTypes ST ON LT.ServiceTypeID = ST.ServiceTypeID
    WHERE LT.BranchID = @BranchID
      AND (@ServiceTypeID IS NULL OR LT.ServiceTypeID = @ServiceTypeID)
      AND (@IsActiveOnly = 0 OR LT.IsActive = 1)
    ORDER BY LT.TaskName;
END;

GO
