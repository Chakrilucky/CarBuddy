SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PendingDeliveries]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        j.JobCardID,
        c.FullName AS CustomerName,
        c.MobileNumber,
        v.Manufacturer,
        v.Model,
        v.RegistrationNumber,
        j.JobStatus,
        j.EstimatedDelivery,
        j.ActualDelivery,
        CASE 
            WHEN j.ActualDelivery IS NULL 
                 AND j.EstimatedDelivery < GETDATE() 
            THEN 'Overdue'
            WHEN j.ActualDelivery IS NULL 
                 AND j.EstimatedDelivery BETWEEN @FromDate AND @ToDate
            THEN 'Due Today'
            ELSE 'Upcoming'
        END AS DeliveryStatus
    FROM JobCards j
    INNER JOIN Customers c ON j.CustomerID = c.CustomerID
    INNER JOIN Vehicles v ON j.VehicleID = v.VehicleID
    WHERE 
        j.BranchID = @BranchID
        AND j.JobStatus NOT IN ('Delivered', 'Cancelled')
        AND j.EstimatedDelivery BETWEEN @FromDate AND @ToDate
    ORDER BY 
        j.EstimatedDelivery ASC;
END

GO
