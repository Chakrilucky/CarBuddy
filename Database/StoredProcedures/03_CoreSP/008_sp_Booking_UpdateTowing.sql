SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_UpdateTowing]
(
    @BookingID INT,
    @HasTowing BIT,
    @TowingRequestID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AppointmentBookings
    SET 
        HasTowing = @HasTowing,
        TowingRequestID = @TowingRequestID,
        UpdatedDate = GETDATE()
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;
END;

GO
