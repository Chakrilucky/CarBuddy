CREATE OR ALTER PROCEDURE sp_ApplyServicePriority
    @JobCardId INT,
    @PriorityType NVARCHAR(20),   -- Normal / Premium
    @ExtraCharge DECIMAL(10,2),
    @AppliedByUserId INT
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

        /* 2️⃣ Validate Priority Type */
        IF @PriorityType NOT IN ('Normal', 'Premium')
        BEGIN
            RAISERROR ('Invalid Priority Type.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 3️⃣ Prevent duplicate Premium entry */
        IF @PriorityType = 'Premium'
           AND EXISTS (
               SELECT 1
               FROM ServicePriorityLog
               WHERE JobCardId = @JobCardId
                 AND PriorityType = 'Premium'
           )
        BEGIN
            RAISERROR ('Premium priority already applied for this Job Card.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* 4️⃣ Insert priority log */
        INSERT INTO ServicePriorityLog
        (
            JobCardId,
            PriorityType,
            ExtraCharge,
            AppliedByUserId,
            AppliedDate
        )
        VALUES
        (
            @JobCardId,
            @PriorityType,
            CASE WHEN @PriorityType = 'Premium' THEN @ExtraCharge ELSE 0 END,
            @AppliedByUserId,
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
