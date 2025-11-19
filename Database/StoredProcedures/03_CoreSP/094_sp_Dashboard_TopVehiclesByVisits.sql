SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopVehiclesByVisits]
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
        COUNT(j.JobCardID) AS VisitCount,
        MIN(j.CreatedDate) AS FirstVisitDate,
        MAX(j.CreatedDate) AS LastVisitDate
    FROM JobCards j
    INNER JOIN Vehicles v ON j.VehicleID = v.VehicleID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        v.Manufacturer, v.Model
    ORDER BY 
        VisitCount DESC;
END

GO
