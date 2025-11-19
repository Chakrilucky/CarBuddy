SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PendingJobCards]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        J.JobCardID,
        J.JobCardNumber,
        C.FullName AS CustomerName,
        C.MobileNumber,
        V.RegistrationNumber,
        V.Manufacturer,
        V.Model,
        ST.ServiceName AS ServiceType,
        PT.PriorityName,
        T.TechnicianName AS AssignedTechnician,
        J.JobStatus,
        J.EstimatedDelivery,
        J.CreatedDate
    FROM JobCards J
    INNER JOIN Customers C ON J.CustomerID = C.CustomerID
    INNER JOIN Vehicles V ON J.VehicleID = V.VehicleID
    INNER JOIN ServiceTypes ST ON J.ServiceTypeID = ST.ServiceTypeID
    INNER JOIN PriorityTypes PT ON J.PriorityTypeID = PT.PriorityTypeID
    LEFT JOIN Technicians T ON J.AssignedTechnicianID = T.TechnicianID
    WHERE 
        J.JobStatus NOT IN ('Delivered', 'Completed')
        AND J.BranchID = @BranchID
    ORDER BY 
        J.CreatedDate DESC;
END;

GO
