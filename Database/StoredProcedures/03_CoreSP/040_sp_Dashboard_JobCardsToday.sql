SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobCardsToday]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    SELECT 
        J.JobCardID,
        J.JobCardNumber,
        J.CustomerID,
        C.FullName AS CustomerName,
        C.MobileNumber AS CustomerMobile,
        V.RegistrationNumber,
        V.Manufacturer,
        V.Model,
        ST.ServiceName AS ServiceType,
        PT.PriorityName,
        T.TechnicianName AS AssignedTechnician,
        J.JobStatus,
        J.CreatedDate
    FROM JobCards J
    INNER JOIN Customers C ON J.CustomerID = C.CustomerID
    INNER JOIN Vehicles V ON J.VehicleID = V.VehicleID
    INNER JOIN ServiceTypes ST ON J.ServiceTypeID = ST.ServiceTypeID
    INNER JOIN PriorityTypes PT ON J.PriorityTypeID = PT.PriorityTypeID
    LEFT JOIN Technicians T ON J.AssignedTechnicianID = T.TechnicianID
    WHERE 
        CAST(J.CreatedDate AS DATE) = @Today
        AND J.BranchID = @BranchID
    ORDER BY 
        J.CreatedDate DESC;
END;

GO
