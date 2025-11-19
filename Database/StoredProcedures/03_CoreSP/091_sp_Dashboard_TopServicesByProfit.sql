SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopServicesByProfit]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------------
    -- SERVICE-WISE PROFIT (Assuming LabourAmount is pure profit)
    -----------------------------------------------------------------------
    SELECT TOP (@TopCount)
        st.ServiceName,
        COUNT(j.JobCardID) AS TotalJobs,
        SUM(i.LabourAmount) AS TotalProfit,
        SUM(i.NetAmount) AS TotalRevenue,
        AVG(i.LabourAmount) AS AvgProfitPerJob
    FROM JobCards j
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        TotalProfit DESC;

END

GO
