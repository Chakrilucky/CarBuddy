SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_StatusUpdate]
(
    @BookingID INT,
    @BookingStatus VARCHAR(50),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AppointmentBookings
    SET 
        BookingStatus = @BookingStatus,
        UpdatedDate = GETDATE()
    WHERE 
        BookingID = @BookingID
        AND BranchID = @BranchID;
END;

GO
