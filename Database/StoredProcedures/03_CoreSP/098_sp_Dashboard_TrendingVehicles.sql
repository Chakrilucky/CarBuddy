SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TrendingVehicles]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        v.Manufacturer,
        v.Model,
        COUNT(j.JobCardID) AS VisitCount
    FROM JobCards j
    INNER JOIN Vehicles v 
        ON j.VehicleID = v.VehicleID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND v.IsActive = 1
    GROUP BY 
        v.Manufacturer, v.Model
    ORDER BY 
        VisitCount DESC;
END

GO
