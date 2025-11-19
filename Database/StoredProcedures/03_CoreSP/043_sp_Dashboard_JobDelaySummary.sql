SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobDelaySummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- 1. DELAYED JOBS SUMMARY
    ------------------------------------------------------------
    SELECT 
        COUNT(*) AS TotalDelayedJobs,
        AVG(DATEDIFF(HOUR,
                      j.EstimatedDelivery,
                      ISNULL(j.ActualDelivery, GETDATE()))
        ) AS AvgDelayHours
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.EstimatedDelivery IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND (
                (j.ActualDelivery IS NOT NULL AND j.ActualDelivery > j.EstimatedDelivery)
             OR (j.ActualDelivery IS NULL AND GETDATE() > j.EstimatedDelivery)
            );



    ------------------------------------------------------------
    -- 2. DELAY BY SERVICE CATEGORY
    ------------------------------------------------------------
    SELECT 
        st.ServiceName,
        COUNT(*) AS DelayedJobs,
        AVG(DATEDIFF(HOUR,
                      j.EstimatedDelivery,
                      ISNULL(j.ActualDelivery, GETDATE()))
        ) AS AvgDelayHours
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.EstimatedDelivery IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND (
                (j.ActualDelivery IS NOT NULL AND j.ActualDelivery > j.EstimatedDelivery)
             OR (j.ActualDelivery IS NULL AND GETDATE() > j.EstimatedDelivery)
            )
    GROUP BY 
        st.ServiceName
    ORDER BY 
        DelayedJobs DESC;



    ------------------------------------------------------------
    -- 3. DELAY BY TECHNICIAN
    ------------------------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        COUNT(*) AS DelayedJobs,
        AVG(DATEDIFF(HOUR,
                      j.EstimatedDelivery,
                      ISNULL(j.ActualDelivery, GETDATE()))
        ) AS AvgDelayHours
    FROM JobCards j
    INNER JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND u.Role = 'Technician'
        AND j.EstimatedDelivery IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND (
                (j.ActualDelivery IS NOT NULL AND j.ActualDelivery > j.EstimatedDelivery)
             OR (j.ActualDelivery IS NULL AND GETDATE() > j.EstimatedDelivery)
            )
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        DelayedJobs DESC;



    ------------------------------------------------------------
    -- 4. INDIVIDUAL DELAYED JOB LIST
    ------------------------------------------------------------
    SELECT 
        j.JobCardID,
        j.JobStatus,
        j.EstimatedDelivery,
        j.ActualDelivery,
        DATEDIFF(HOUR, j.EstimatedDelivery, ISNULL(j.ActualDelivery, GETDATE())) AS DelayHours,
        j.Remarks,
        st.ServiceName,
        u.FullName AS Technician
    FROM JobCards j
    LEFT JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    LEFT JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND j.EstimatedDelivery IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND (
                (j.ActualDelivery IS NOT NULL AND j.ActualDelivery > j.EstimatedDelivery)
             OR (j.ActualDelivery IS NULL AND GETDATE() > j.EstimatedDelivery)
            )
    ORDER BY 
        DelayHours DESC;
END

GO
