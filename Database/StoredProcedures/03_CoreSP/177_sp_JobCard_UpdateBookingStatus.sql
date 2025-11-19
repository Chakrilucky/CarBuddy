SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_UpdateBookingStatus]
(
    @BookingID INT,
    @Status VARCHAR(50),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AppointmentBookings
    SET 
        BookingStatus = @Status,
        UpdatedDate = GETDATE()
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;
END;

GO
