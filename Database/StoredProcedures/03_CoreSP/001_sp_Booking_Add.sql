SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Booking_Add]
(
    @SlotID INT,
    @CustomerID INT,
    @VehicleID INT,
    @PriorityTypeID INT,     -- 1 = Normal, 2 = Premium
    @HasTowing BIT = 0,
    @TowingRequestID INT = NULL,  -- only if HasTowing = 1
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AppointmentBookings
    (
        SlotID,
        CustomerID,
        VehicleID,
        PriorityTypeID,
        BookingStatus,
        HasTowing,
        TowingRequestID,
        Notes,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @SlotID,
        @CustomerID,
        @VehicleID,
        @PriorityTypeID,
        'Pending',
        @HasTowing,
        @TowingRequestID,
        @Notes,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS BookingID;
END;

GO
