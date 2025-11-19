SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodayActivitySummary]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------------
    -- TODAY'S DATE
    ------------------------------------------------------------------------
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);



    ------------------------------------------------------------------------
    -- 1. TODAY NEW JOB CARDS CREATED
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS TodayNewJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND CAST(CreatedDate AS DATE) = @Today;



    ------------------------------------------------------------------------
    -- 2. TODAY COMPLETED JOBS
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS TodayCompletedJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND JobStatus = 'Delivered'
        AND CAST(CompletedOn AS DATE) = @Today;



    ------------------------------------------------------------------------
    -- 3. TODAY READY FOR DELIVERY
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS TodayReadyForDelivery
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND JobStatus = 'ReadyForDelivery'
        AND CAST(UpdatedDate AS DATE) = @Today;



    ------------------------------------------------------------------------
    -- 4. TODAY PENDING HANDOVERS
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS TodayPendingHandover
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND JobStatus IN ('ReadyForDelivery','QCPending')
        AND CAST(UpdatedDate AS DATE) = @Today;



    ------------------------------------------------------------------------
    -- 5. TODAY JOB LIST DETAILS
    ------------------------------------------------------------------------
    SELECT 
        JobCardID,
        JobCardNumber,
        VehicleID,
        JobStatus,
        CreatedDate,
        CompletedOn,
        ActualDelivery
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND CAST(CreatedDate AS DATE) = @Today
    ORDER BY 
        CreatedDate DESC;

END

GO
