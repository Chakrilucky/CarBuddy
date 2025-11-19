SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_Update]
(
    @BookingID INT,
    @SlotID INT,
    @PriorityTypeID INT,
    @Notes NVARCHAR(MAX),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AppointmentBookings
    SET
        SlotID = @SlotID,
        PriorityTypeID = @PriorityTypeID,
        Notes = @Notes,
        UpdatedDate = GETDATE()
    WHERE
        BookingID = @BookingID
        AND BranchID = @BranchID;
END;

GO
