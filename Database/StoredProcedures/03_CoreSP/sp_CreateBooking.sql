-- sp_CreateBooking.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateBooking','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateBooking;
GO
CREATE PROCEDURE dbo.sp_CreateBooking
  @BookingNo NVARCHAR(50),
  @CustomerId INT,
  @VehicleId INT,
  @SlotId INT,
  @ServicesSequence NVARCHAR(MAX) = NULL,
  @AdvanceAmount DECIMAL(18,2) = 0,
  @CreatedBy INT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @SlotDate DATE = NULL, @SlotFrom TIME = NULL;
  SELECT @SlotDate = [Date], @SlotFrom = TimeFrom FROM dbo.Slots WHERE SlotId = @SlotId;

  DECLARE @SlotStart DATETIME2 = NULL;
  IF @SlotDate IS NOT NULL AND @SlotFrom IS NOT NULL
    SET @SlotStart = DATEADD(SECOND, DATEDIFF(SECOND, 0, @SlotFrom), CAST(@SlotDate AS DATETIME2));

  DECLARE @RefundableUntil DATETIME2 = NULL;
  IF @SlotStart IS NOT NULL
    SET @RefundableUntil = DATEADD(HOUR, -24, @SlotStart);

  BEGIN TRAN;
  BEGIN TRY
    INSERT INTO dbo.Bookings (BookingNo, CustomerId, VehicleId, SlotId, ServicesSequence, AdvanceAmount, PaidAmount, PaymentStatus, BookingStatus, CreatedAt, RefundableUntil)
    VALUES (@BookingNo, @CustomerId, @VehicleId, @SlotId, @ServicesSequence, @AdvanceAmount, 0, 'PENDING', 'BOOKED', SYSUTCDATETIME(), @RefundableUntil);

    DECLARE @NewBookingId INT = CONVERT(INT,SCOPE_IDENTITY());

    -- increment slot occupancy
    UPDATE dbo.Slots SET OccupiedCount = ISNULL(OccupiedCount,0) + 1 WHERE SlotId = @SlotId;

    COMMIT TRAN;
    SELECT @NewBookingId AS BookingId, @RefundableUntil AS RefundableUntil;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH
END
GO
