SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_WorkshopHealthSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);



    /* -------------------------------------------------------------
       1. TOTAL JOBS SUMMARY
    ---------------------------------------------------------------*/
    SELECT 
        COUNT(*) AS TotalJobs,
        SUM(CASE WHEN JobStatus = 'Delivered' THEN 1 ELSE 0 END) AS DeliveredJobs,
        SUM(CASE WHEN JobStatus NOT IN ('Delivered','Cancelled') THEN 1 ELSE 0 END) AS PendingJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    /* -------------------------------------------------------------
       2. TODAY’S JOB ACTIVITY
    ---------------------------------------------------------------*/
    SELECT 
        SUM(CASE WHEN CAST(CreatedDate AS DATE) = @Today THEN 1 ELSE 0 END) AS TodayNewJobs,
        SUM(CASE WHEN JobStatus = 'Delivered' 
                 AND CAST(CompletedOn AS DATE) = @Today THEN 1 ELSE 0 END) AS TodayDeliveredJobs,
        SUM(CASE WHEN JobStatus = 'ReadyForDelivery' 
                 AND CAST(UpdatedDate AS DATE) = @Today THEN 1 ELSE 0 END) AS TodayReadyForDelivery
    FROM JobCards
    WHERE BranchID = @BranchID;



    /* -------------------------------------------------------------
       3. WORKFLOW STAGE BREAKDOWN
    ---------------------------------------------------------------*/
    SELECT 
        JobStatus,
        COUNT(*) AS Jobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY JobStatus
    ORDER BY Jobs DESC;



    /* -------------------------------------------------------------
       4. AVERAGE TAT (TURNAROUND TIME)
    ---------------------------------------------------------------*/
    SELECT 
        AVG(DATEDIFF(HOUR, CreatedDate, CompletedOn)) AS AvgTATHours
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND JobStatus = 'Delivered'
        AND CompletedOn IS NOT NULL
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    /* -------------------------------------------------------------
       5. INSURANCE CLAIM SUMMARY
    ---------------------------------------------------------------*/
    SELECT 
        COUNT(c.InsuranceClaimID) AS TotalClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Approved' THEN 1 ELSE 0 END) AS ApprovedClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Rejected' THEN 1 ELSE 0 END) AS RejectedClaims
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON j.JobCardID = c.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate;



    /* -------------------------------------------------------------
       6. PRIORITY (NORMAL vs PREMIUM)
    ---------------------------------------------------------------*/
    SELECT 
        PriorityTypeID,
        COUNT(*) AS TotalJobs
    FROM JobCards
    WHERE BranchID = @BranchID
      AND CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY PriorityTypeID;



    /* -------------------------------------------------------------
       7. DENTING / PAINTING LOAD (Including Full Body Painting)
    ---------------------------------------------------------------*/
    SELECT 
        ServiceTypeID,
        COUNT(*) AS TotalJobs
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND ServiceTypeID IN (SELECT ServiceTypeID FROM ServiceTypes 
                              WHERE ServiceName LIKE '%Paint%'
                                 OR ServiceName LIKE '%Denting%'
                                 OR ServiceName LIKE '%Full Body%')
        AND CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY ServiceTypeID;



    /* -------------------------------------------------------------
       8. TECHNICIAN COUNT & LOAD
    ---------------------------------------------------------------*/
    SELECT 
        u.Role,
        COUNT(*) AS StaffCount
    FROM Users u
    WHERE 
        u.BranchID = @BranchID
    GROUP BY u.Role;

END

GO
