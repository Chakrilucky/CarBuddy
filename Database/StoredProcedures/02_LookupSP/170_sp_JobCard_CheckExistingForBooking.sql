SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_CheckExistingForBooking]
(
    @BookingID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        JC.JobCardID,
        JC.JobCardNumber
    FROM JobCards JC
    INNER JOIN AppointmentBookings AB 
        ON JC.CustomerID = AB.CustomerID
       AND JC.VehicleID = AB.VehicleID
       AND AB.BookingID = @BookingID
    WHERE JC.BranchID = @BranchID
      AND AB.BranchID = @BranchID;
END;

GO
