SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_GetByID]
(
    @BookingID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM AppointmentBookings
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;
END;

GO
