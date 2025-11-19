SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_AutoUpdateStatus]
    @JobCardID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @PendingCount INT,
        @InProgressCount INT,
        @CompletedCount INT,
        @TotalStages INT,
        @NewStatus VARCHAR(50);

    SELECT
        @PendingCount = SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END),
        @InProgressCount = SUM(CASE WHEN Status = 'InProgress' THEN 1 ELSE 0 END),
        @CompletedCount = SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END),
        @TotalStages = COUNT(*)
    FROM JobCardStages
    WHERE JobCardId = @JobCardID
      AND BranchID = @BranchID;

    -------------------------------------------------------
    -- Determine the JobCard Status
    -------------------------------------------------------
    IF @CompletedCount = @TotalStages
        SET @NewStatus = 'Completed';

    ELSE IF @InProgressCount > 0
        SET @NewStatus = 'InProgress';

    ELSE 
        SET @NewStatus = 'Created';

    -------------------------------------------------------
    -- Update JobCard Table
    -------------------------------------------------------
    UPDATE JobCards
    SET 
        JobStatus = @NewStatus,
        CompletedOn = CASE WHEN @NewStatus = 'Completed' THEN GETDATE() ELSE NULL END,
        UpdatedDate = GETDATE()
    WHERE JobCardID = @JobCardID
      AND BranchID = @BranchID;

    SELECT @NewStatus AS JobStatus;
END;

GO
