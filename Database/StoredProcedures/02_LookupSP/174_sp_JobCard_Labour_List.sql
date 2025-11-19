SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_Labour_List]
(
    @JobCardID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.LabourID,
        L.JobCardID,
        L.TechnicianID,
        T.TechnicianName AS TechnicianName,   -- FIXED
        L.LabourType,
        L.Description,
        L.LabourHours,
        L.LabourRate,
        L.TotalLabourCost,
        L.WorkStatus,
        L.StartTime,
        L.EndTime,
        L.Notes,
        L.CreatedDate,
        L.UpdatedDate
    FROM JobLabourTracking L
    LEFT JOIN Technicians T ON L.TechnicianID = T.TechnicianID
    WHERE L.JobCardID = @JobCardID
      AND L.BranchID = @BranchID
    ORDER BY L.LabourID DESC;
END;

GO
