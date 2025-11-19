SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopVehiclesByRevenue]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        v.Manufacturer,
        v.Model,
        COUNT(j.JobCardID) AS TotalJobs,
        SUM(i.NetAmount) AS TotalRevenue,
        AVG(CAST(i.NetAmount AS DECIMAL(10,2))) AS AvgRevenuePerJob
    FROM JobCards j
    INNER JOIN Vehicles v ON j.VehicleID = v.VehicleID
    INNER JOIN Invoices i ON j.JobCardID = i.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        v.Manufacturer, v.Model
    ORDER BY 
        TotalRevenue DESC;
END

GO
