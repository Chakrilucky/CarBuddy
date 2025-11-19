SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        B.BookingID,
        B.SlotID,
        B.CustomerID,
        C.FullName AS CustomerName,
        B.VehicleID,
        V.RegistrationNumber,
        B.PriorityTypeID,
        PT.PriorityName,   -- FIXED HERE
        B.BookingStatus,
        B.HasTowing,
        B.TowingRequestID,
        B.Notes,
        B.CreatedDate
    FROM AppointmentBookings B
    LEFT JOIN Customers C ON B.CustomerID = C.CustomerID
    LEFT JOIN Vehicles V ON B.VehicleID = V.VehicleID
    LEFT JOIN PriorityTypes PT ON B.PriorityTypeID = PT.PriorityTypeID
    WHERE B.BranchID = @BranchID
    ORDER BY B.CreatedDate DESC, B.BookingID DESC;
END;

GO
