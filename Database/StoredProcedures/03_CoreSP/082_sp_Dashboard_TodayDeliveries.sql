SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodayDeliveries]
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
        C.FullName AS CustomerName,
        C.MobileNumber,
        V.RegistrationNumber,
        V.Manufacturer,
        V.Model,
        ST.ServiceName AS ServiceType,
        PT.PriorityName,
        J.JobStatus,
        J.ActualDelivery,
        I.InvoiceNumber,
        I.GrandTotal AS InvoiceAmount
    FROM JobCards J
    INNER JOIN Customers C ON J.CustomerID = C.CustomerID
    INNER JOIN Vehicles V ON J.VehicleID = V.VehicleID
    INNER JOIN ServiceTypes ST ON J.ServiceTypeID = ST.ServiceTypeID
    INNER JOIN PriorityTypes PT ON J.PriorityTypeID = PT.PriorityTypeID
    LEFT JOIN JobInvoices I ON J.JobCardID = I.JobCardID
    WHERE 
        CAST(J.ActualDelivery AS DATE) = @Today
        AND J.BranchID = @BranchID
    ORDER BY 
        J.ActualDelivery DESC;
END;

GO
