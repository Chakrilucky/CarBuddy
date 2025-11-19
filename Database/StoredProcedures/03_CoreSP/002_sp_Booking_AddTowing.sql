SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_AddTowing]
(
    @BookingID INT,
    @TowingRequestID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AppointmentBookings
    SET 
        HasTowing = 1,
        TowingRequestID = @TowingRequestID,
        UpdatedDate = GETDATE()
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;
END;

GO
