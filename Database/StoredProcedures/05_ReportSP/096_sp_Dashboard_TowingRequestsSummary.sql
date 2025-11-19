SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TowingRequestsSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    -----------------------------------------------------------
    -- 1. TOTAL TOWING REQUESTS SUMMARY
    -----------------------------------------------------------
    SELECT 
        COUNT(*) AS TotalTowingRequests,
        SUM(CASE WHEN JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS CompletedTowing,
        SUM(CASE WHEN JobStatus <> 'Delivered' THEN 1 ELSE 0 END) AS PendingTowing
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    -----------------------------------------------------------
    -- 2. TOWING JOB DETAILS LIST
    -----------------------------------------------------------
    SELECT 
        JobCardID,
        CustomerID,
        VehicleID,
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



    -----------------------------------------------------------
    -- 3. TOP TOWING REASONS (BASED ON NOTES)
    -----------------------------------------------------------
    SELECT TOP 10
        TowingNotes,
        COUNT(*) AS CountOfNotes
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND HasTowing = 1
        AND TowingNotes IS NOT NULL
        AND LTRIM(RTRIM(TowingNotes)) <> ''
        AND CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        TowingNotes
    ORDER BY 
        CountOfNotes DESC;

END

GO
