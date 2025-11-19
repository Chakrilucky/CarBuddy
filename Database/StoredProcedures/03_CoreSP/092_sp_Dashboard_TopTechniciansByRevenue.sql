SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopTechniciansByRevenue]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10      -- default = top 10 technicians
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        u.UserID,
        u.FullName,
        COUNT(j.JobCardID) AS TotalJobs,
        SUM(i.NetAmount) AS TotalRevenue,
        AVG(CAST(i.NetAmount AS DECIMAL(10,2))) AS AvgRevenuePerJob
    FROM JobCards j
    INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
    INNER JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND u.Role = 'Technician'
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        TotalRevenue DESC;
END

GO
