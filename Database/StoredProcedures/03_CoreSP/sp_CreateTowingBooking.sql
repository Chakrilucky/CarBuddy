-- sp_CreateTowingBooking.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateTowingBooking','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateTowingBooking;
GO
CREATE PROCEDURE dbo.sp_CreateTowingBooking
  @JobId INT = NULL,                  -- JobCardID
  @CustomerId INT,
  @PickupAddress NVARCHAR(1000),
  @DropAddress NVARCHAR(1000),
  @DistanceKm DECIMAL(9,2),
  @CarType NVARCHAR(50),
  @Condition NVARCHAR(50),
  @LocationType NVARCHAR(50),
  @RequestedAt DATETIME2,
  @QuoteAmount DECIMAL(18,2),
  @AdvanceAmount DECIMAL(18,2),
  @CreatedBy INT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN;
  BEGIN TRY
    INSERT INTO dbo.TowingBookings (JobId, CustomerId, PickupAddress, DropAddress, DistanceKm, CarType, Condition, LocationType, RequestedAt, QuoteAmount, AdvanceAmount, PaymentStatus, Status, AssignedVehicleId, AssignedDriverId, CreatedBy, CreatedAt)
    VALUES (@JobId, @CustomerId, @PickupAddress, @DropAddress, @DistanceKm, @CarType, @Condition, @LocationType, @RequestedAt, @QuoteAmount, @AdvanceAmount, 'PENDING', 'PENDING', NULL, NULL, @CreatedBy, SYSUTCDATETIME());

    DECLARE @NewId INT = CONVERT(INT,SCOPE_IDENTITY());

    IF @JobId IS NOT NULL AND OBJECT_ID('dbo.JobStatusHistory','U') IS NOT NULL
    BEGIN
      INSERT INTO dbo.JobStatusHistory (JobId, OldStatus, NewStatus, ChangedBy, ChangedAt, Comment)
      VALUES (@JobId, NULL, 'TowingBooked', @CreatedBy, SYSUTCDATETIME(), CONCAT('Towing booking created #', @NewId));
    END

    COMMIT TRAN;
    SELECT @NewId AS TowingBookingId, 1 AS Success;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH
END
GO
