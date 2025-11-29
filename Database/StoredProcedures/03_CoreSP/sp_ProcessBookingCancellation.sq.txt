-- sp_ProcessBookingCancellation.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_ProcessBookingCancellation','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_ProcessBookingCancellation;
GO
CREATE PROCEDURE dbo.sp_ProcessBookingCancellation
  @BookingId INT,
  @RequestedBy INT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RefundableUntil DATETIME2, @Now DATETIME2 = SYSUTCDATETIME(), @Advance DECIMAL(18,2)=0, @SlotId INT = NULL;

  SELECT @RefundableUntil = RefundableUntil, @Advance = AdvanceAmount, @SlotId = SlotId
  FROM dbo.Bookings WHERE BookingId = @BookingId;

  IF @RefundableUntil IS NULL
  BEGIN
    RAISERROR('Booking not found or RefundableUntil not set',16,1);
    RETURN;
  END

  BEGIN TRAN;
  BEGIN TRY
    UPDATE dbo.Bookings SET BookingStatus='Cancelled' WHERE BookingId = @BookingId;

    IF @SlotId IS NOT NULL
      UPDATE dbo.Slots SET OccupiedCount = CASE WHEN OccupiedCount > 0 THEN OccupiedCount - 1 ELSE 0 END WHERE SlotId = @SlotId;

    IF @Now <= @RefundableUntil
    BEGIN
      -- create refund intent record in BookingPayments
      INSERT INTO dbo.BookingPayments (BookingId, PaymentGateway, Amount, Status, TransactionRef, PaidAt)
      VALUES (@BookingId, 'SYSTEM_REFUND', -@Advance, 'RefundInitiated', NULL, SYSUTCDATETIME());

      -- if BookingCancellationRequests table exists, insert a request record
      IF OBJECT_ID('dbo.BookingCancellationRequests','U') IS NOT NULL
      BEGIN
        INSERT INTO dbo.BookingCancellationRequests (booking_id, requested_by, requested_at, status, refund_amount)
        VALUES (@BookingId, @RequestedBy, SYSUTCDATETIME(), 'Approved', @Advance);
      END

      COMMIT TRAN;
      SELECT 1 AS Success, @Advance AS RefundAmount, 'FullRefund' AS RefundType;
    END
    ELSE
    BEGIN
      IF OBJECT_ID('dbo.BookingCancellationRequests','U') IS NOT NULL
      BEGIN
        INSERT INTO dbo.BookingCancellationRequests (booking_id, requested_by, requested_at, status, refund_amount)
        VALUES (@BookingId, @RequestedBy, SYSUTCDATETIME(), 'Approved', 0);
      END

      COMMIT TRAN;
      SELECT 1 AS Success, 0 AS RefundAmount, 'NoRefund' AS RefundType;
    END
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH
END
GO
