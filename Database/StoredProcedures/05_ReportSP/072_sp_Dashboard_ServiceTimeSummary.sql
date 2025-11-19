SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ServiceTimeSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    ---------------------------------------------------------
    -- 1. SERVICE CATEGORY WISE AVERAGE JOB TIME
    ---------------------------------------------------------
    SELECT 
        st.ServiceName,
        AVG(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS AvgServiceHours,
        MIN(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS MinServiceHours,
        MAX(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS MaxServiceHours,
        COUNT(j.JobCardID) AS TotalJobs
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        AvgServiceHours ASC;



    ---------------------------------------------------------
    -- 2. TECHNICIAN WISE AVERAGE SERVICE TIME
    ---------------------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        AVG(DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)) AS AvgServiceHours,
        COUNT(j.JobCardID) AS TotalJobs
    FROM JobCards j
    INNER JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND u.Role = 'Technician'
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        AvgServiceHours ASC;



    ---------------------------------------------------------
    -- 3. FASTEST & SLOWEST COMPLETED JOBS
    ---------------------------------------------------------
    SELECT TOP 10
        j.JobCardID,
        st.ServiceName,
        u.FullName AS Technician,
        j.CreatedDate,
        j.CompletedOn,
        DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn) AS TotalHours
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    LEFT JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY TotalHours ASC;   -- fastest jobs first



    ---------------------------------------------------------
    -- 4. SLOWEST JOBS (TOP 10)
    ---------------------------------------------------------
    SELECT TOP 10
        j.JobCardID,
        st.ServiceName,
        u.FullName AS Technician,
        j.CreatedDate,
        j.CompletedOn,
        DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn) AS TotalHours
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    LEFT JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND j.CompletedOn IS NOT NULL
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY TotalHours DESC;   -- slowest jobs first

END

GO
