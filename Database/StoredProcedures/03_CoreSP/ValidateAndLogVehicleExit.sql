CREATE OR ALTER PROCEDURE sp_ValidateAndLogVehicleExit
    @JobCardId INT,
    @VehicleID INT,
    @ExitType NVARCHAR(20),     -- TestDrive / Delivery
    @ScannedByUserId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* 1️⃣ Validate JobCard */
        IF NOT EXISTS (
            SELECT 1 FROM JobCards WHERE JobCardID = @JobCardId
        )
        BEGIN
            RAISERROR ('Invalid Job Card.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 2️⃣ Validate Vehicle */
        IF NOT EXISTS (
            SELECT 1 FROM Vehicles WHERE VehicleID = @VehicleID
        )
        BEGIN
            RAISERROR ('Invalid Vehicle.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 3️⃣ Exit type validation */
        IF @ExitType NOT IN ('TestDrive', 'Delivery')
        BEGIN
            RAISERROR ('Invalid Exit Type.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 4️⃣ DELIVERY → At least one payment must exist */
        IF @ExitType = 'Delivery'
        BEGIN
            IF NOT EXISTS (
                SELECT 1
                FROM Payments
                WHERE JobCardID = @JobCardId
            )
            BEGIN
                RAISERROR ('No payment found. Delivery not allowed.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        /* 5️⃣ Log vehicle exit */
        INSERT INTO VehicleExitGateLog
        (
            JobCardId,
            VehicleID,
            ExitType,
            PaymentCleared,
            InsuranceCleared,
            ScannedByUserId,
            ExitDateTime
        )
        VALUES
        (
            @JobCardId,
            @VehicleID,
            @ExitType,
            CASE WHEN @ExitType = 'Delivery' THEN 1 ELSE 0 END,
            1,
            @ScannedByUserId,
            GETDATE()
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT
            @ErrMsg = ERROR_MESSAGE(),
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR (@ErrMsg, @ErrSeverity, 1);
    END CATCH
END;
GO
