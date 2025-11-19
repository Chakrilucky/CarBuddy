SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TowRequestsSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------
    -- 1. TOTAL TOWING REQUESTS
    ------------------------------------------------
    SELECT 
        COUNT(*) AS TotalTowRequests
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND CreatedDate BETWEEN @FromDate AND @ToDate;


    ------------------------------------------------
    -- 2. COMPLETED TOW REQUESTS (Delivered jobs)
    ------------------------------------------------
    SELECT 
        COUNT(*) AS CompletedTowingJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND JobStatus = 'Delivered'
        AND CreatedDate BETWEEN @FromDate AND @ToDate;


    ------------------------------------------------
    -- 3. PENDING TOW REQUESTS
    ------------------------------------------------
    SELECT 
        COUNT(*) AS PendingTowingJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND JobStatus NOT IN ('Delivered', 'Cancelled')
        AND CreatedDate BETWEEN @FromDate AND @ToDate;


    ------------------------------------------------
    -- 4. TOWING DETAILS LIST
    ------------------------------------------------
    SELECT 
        JobCardID,
        TowingNotes,
        JobStatus,
        CreatedDate
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        CreatedDate DESC;
END

GO
