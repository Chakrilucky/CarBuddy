SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_Labour_Add]
(
    @JobCardID INT,
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

    INSERT INTO JobLabourTracking
    (
        JobCardID,
        TechnicianID,
        LabourType,
        Description,
        LabourHours,
        LabourRate,
        WorkStatus,
        Notes,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @JobCardID,
        @TechnicianID,
        @LabourType,
        @Description,
        @LabourHours,
        @LabourRate,
        @WorkStatus,
        @Notes,
        GETDATE(),
        @BranchID
    );
END;

GO
