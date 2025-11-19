SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LabourTracking_Add]
    @JobCardID INT,
    @TechnicianID INT,
    @LabourType VARCHAR(100),
    @Description NVARCHAR(MAX),
    @LabourHours DECIMAL(18,2),
    @LabourRate DECIMAL(18,2),
    @Notes NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- NOTE:
    -- TotalLabourCost is a computed column (LabourHours * LabourRate)
    -- so we do NOT insert it manually.

    INSERT INTO JobLabourTracking
    (
        JobCardID,
        TechnicianID,
        LabourType,
        Description,
        LabourHours,
        LabourRate,
        WorkStatus,
        StartTime,
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
        'InProgress',
        GETDATE(),
        @Notes,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS LabourID;
END;

GO
