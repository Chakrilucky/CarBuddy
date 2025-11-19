SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ServiceRevenueBreakdown]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.ServiceName,
        COUNT(j.JobCardID) AS TotalJobs,
        SUM(i.NetAmount) AS TotalRevenue,
        AVG(CAST(i.NetAmount AS DECIMAL(10,2))) AS AvgRevenuePerJob
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        TotalRevenue DESC;
END

GO
