SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTask_Add]
(
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

    INSERT INTO LabourTasks
    (
        ServiceTypeID, TaskName, DefaultHours, DefaultRate,
        Description, IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @ServiceTypeID, @TaskName, @DefaultHours, @DefaultRate,
        @Description, @IsActive, GETDATE(), @BranchID
    );
END;

GO
