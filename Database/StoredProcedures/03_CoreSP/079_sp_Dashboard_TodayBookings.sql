SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodayBookings]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    SELECT 
        B.BookingID,
        B.SlotID,
        C.FullName AS CustomerName,
        C.MobileNumber,
        V.RegistrationNumber,
        V.Manufacturer,
        V.Model,
        PT.PriorityName,
        B.BookingStatus,
        B.HasTowing,
        B.TowingRequestID,
        B.Notes,
        S.SlotDate,
        S.StartTime,
        S.EndTime,
        B.CreatedDate
    FROM AppointmentBookings B
    INNER JOIN Customers C ON B.CustomerID = C.CustomerID
    INNER JOIN Vehicles V ON B.VehicleID = V.VehicleID
    INNER JOIN AppointmentSlots S ON B.SlotID = S.SlotID
    INNER JOIN PriorityTypes PT ON B.PriorityTypeID = PT.PriorityTypeID
    WHERE 
        CAST(B.CreatedDate AS DATE) = @Today
        AND B.BranchID = @BranchID
    ORDER BY 
        B.CreatedDate DESC;
END;

GO
