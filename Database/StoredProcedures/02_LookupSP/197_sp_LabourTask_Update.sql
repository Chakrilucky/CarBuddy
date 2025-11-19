SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTask_Update]
(
    @LabourTaskID INT,
    @ServiceTypeID INT,
    @TaskName NVARCHAR(200),
    @DefaultHours DECIMAL(18,2),
    @DefaultRate DECIMAL(18,2),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LabourTasks
    SET
        ServiceTypeID = @ServiceTypeID,
        TaskName = @TaskName,
        DefaultHours = @DefaultHours,
        DefaultRate = @DefaultRate,
        Description = @Description,
        IsActive = @IsActive,
        UpdatedDate = GETDATE()
    WHERE LabourTaskID = @LabourTaskID
      AND BranchID = @BranchID;
END;

GO
