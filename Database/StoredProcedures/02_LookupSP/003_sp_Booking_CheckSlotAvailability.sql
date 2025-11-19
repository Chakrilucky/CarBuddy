SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_CheckSlotAvailability]
(
    @SlotID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS BookingsInSlot
    FROM AppointmentBookings
    WHERE SlotID = @SlotID
      AND BranchID = @BranchID
      AND BookingStatus <> 'Cancelled';
END;

GO
