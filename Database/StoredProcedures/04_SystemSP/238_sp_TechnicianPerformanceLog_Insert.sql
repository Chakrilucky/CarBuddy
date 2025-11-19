SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TechnicianPerformanceLog_Insert]
    @TechnicianID INT,
    @JobCardID INT,
    @WorkType VARCHAR(50),
    @LabourHours DECIMAL(18,2),
    @LabourPoints INT,
    @QualityRating INT,
    @ComebackFlag BIT,
    @PartsAccuracy BIT,
    @Notes NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO TechnicianPerformanceLog
    (
        TechnicianID, JobCardID, WorkType, LabourHours,
        LabourPoints, QualityRating, ComebackFlag,
        PartsAccuracy, Notes, CreatedDate, BranchID
    )
    VALUES
    (
        @TechnicianID, @JobCardID, @WorkType, @LabourHours,
        @LabourPoints, @QualityRating, @ComebackFlag,
        @PartsAccuracy, @Notes, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PerformanceID;
END;

GO
