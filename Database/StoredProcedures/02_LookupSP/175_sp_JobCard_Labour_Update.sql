SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_Labour_Update]
(
    @LabourID INT,
    @TechnicianID INT,
    @LabourType VARCHAR(200),
    @Description NVARCHAR(MAX),
    @LabourHours DECIMAL(18,2),
    @LabourRate DECIMAL(18,2),
    @WorkStatus VARCHAR(50),
    @Notes NVARCHAR(MAX),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobLabourTracking
    SET
        TechnicianID = @TechnicianID,
        LabourType = @LabourType,
        Description = @Description,
        LabourHours = @LabourHours,
        LabourRate = @LabourRate,
        WorkStatus = @WorkStatus,
        Notes = @Notes,
        UpdatedDate = GETDATE()
    WHERE LabourID = @LabourID
      AND BranchID = @BranchID;
END;

GO
