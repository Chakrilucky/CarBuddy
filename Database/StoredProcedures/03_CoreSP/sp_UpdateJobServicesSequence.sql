-- sp_UpdateJobServicesSequence.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_UpdateJobServicesSequence','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_UpdateJobServicesSequence;
GO
CREATE PROCEDURE dbo.sp_UpdateJobServicesSequence
  @JobId INT,                -- pass JobCardID
  @ServicesSequence NVARCHAR(MAX),
  @UpdatedBy INT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN;
  BEGIN TRY
    UPDATE dbo.JobCards
      SET ServicesSequence = @ServicesSequence
    WHERE JobCardID = @JobId;

    IF OBJECT_ID('dbo.JobStatusHistory','U') IS NOT NULL
    BEGIN
      INSERT INTO dbo.JobStatusHistory (JobId, OldStatus, NewStatus, ChangedBy, ChangedAt, Comment)
      VALUES (@JobId, NULL, 'ServicesSequenceSet', @UpdatedBy, SYSUTCDATETIME(), 'Manager set service order');
    END

    COMMIT TRAN;
    SELECT 1 AS Success, @JobId AS JobCardID;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH
END
GO
