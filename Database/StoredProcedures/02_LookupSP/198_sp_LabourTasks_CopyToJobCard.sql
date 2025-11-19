SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTasks_CopyToJobCard]
(
    @JobCardID INT,
    @ServiceTypeID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobLabourTracking
    (
        JobCardID,
        TechnicianID,
        LabourType,
        Description,
        LabourHours,
        LabourRate,
        WorkStatus,
        CreatedDate,
        BranchID
    )
    SELECT
        @JobCardID,
        NULL,                                  -- no technician assigned yet
        LT.TaskName,
        LT.Description,
        LT.DefaultHours,
        LT.DefaultRate,
        'Pending',
        GETDATE(),
        @BranchID
    FROM LabourTasks LT
    WHERE LT.ServiceTypeID = @ServiceTypeID
      AND LT.BranchID = @BranchID
      AND LT.IsActive = 1;
END;

GO
