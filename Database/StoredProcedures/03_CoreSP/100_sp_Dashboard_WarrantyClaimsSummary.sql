SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_WarrantyClaimsSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------
    -- 1. TOTAL WARRANTY JOBS SUMMARY
    -------------------------------------------------------
    SELECT 
        COUNT(*) AS TotalWarrantyJobs,
        SUM(CASE WHEN WarrantyStatus = 'Open' THEN 1 ELSE 0 END) AS OpenWarrantyJobs,
        SUM(CASE WHEN WarrantyStatus = 'Closed' THEN 1 ELSE 0 END) AS ClosedWarrantyJobs
    FROM WarrantyJobs
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    -------------------------------------------------------
    -- 2. WARRANTY BY SERVICE CATEGORY
    -------------------------------------------------------
    SELECT 
        st.ServiceName,
        COUNT(*) AS WarrantyCount
    FROM WarrantyJobs w
    INNER JOIN JobCards j ON w.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        w.BranchID = @BranchID
        AND w.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        WarrantyCount DESC;



    -------------------------------------------------------
    -- 3. TECHNICIAN-WISE WARRANTY COUNT
    -------------------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        COUNT(*) AS WarrantyJobs
    FROM WarrantyJobs w
    INNER JOIN JobCards j ON w.JobCardID = j.JobCardID
    INNER JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        w.BranchID = @BranchID
        AND w.CreatedDate BETWEEN @FromDate AND @ToDate
        AND u.Role = 'Technician'
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        WarrantyJobs DESC;



    -------------------------------------------------------
    -- 4. WARRANTY CASE DETAILS LIST
    -------------------------------------------------------
    SELECT 
        w.WarrantyID,
        w.JobCardID,
        j.JobStatus,
        st.ServiceName,
        u.FullName AS TechnicianName,
        w.IssueDescription,
        w.ResolutionDescription,
        w.WarrantyStatus,
        w.CreatedDate,
        w.ClosedDate
    FROM WarrantyJobs w
    INNER JOIN JobCards j ON w.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    LEFT JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        w.BranchID = @BranchID
        AND w.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        w.CreatedDate DESC;
END

GO
