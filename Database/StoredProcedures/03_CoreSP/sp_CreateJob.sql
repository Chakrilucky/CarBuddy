-- sp_CreateJob.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateJob','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateJob;
GO
CREATE PROCEDURE dbo.sp_CreateJob
  @CustomerId INT,
  @VehicleId INT,
  @CreatedBy INT,                          -- used for JobStatusHistory (audit)
  @ServicesSequence NVARCHAR(MAX) = NULL,
  @IsPriority BIT = 0,
  @EstimatedCompletion DATETIME2 = NULL,
  @RCPhotoPath NVARCHAR(500) = NULL,
  @HandoverId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN;
  BEGIN TRY
    INSERT INTO dbo.JobCards (CustomerID, VehicleID, ServicesSequence, IsPriority, EstimatedCompletion, RCPhotoPath, HandoverId, CreatedDate)
    VALUES (@CustomerId, @VehicleId, @ServicesSequence, @IsPriority, @EstimatedCompletion, @RCPhotoPath, @HandoverId, SYSUTCDATETIME());

    DECLARE @NewJobId INT = CONVERT(INT,SCOPE_IDENTITY());

    IF OBJECT_ID('dbo.JobStatusHistory','U') IS NOT NULL
    BEGIN
      INSERT INTO dbo.JobStatusHistory (JobId, OldStatus, NewStatus, ChangedBy, ChangedAt, Comment)
      VALUES (@NewJobId, NULL, 'CheckedIn', @CreatedBy, SYSUTCDATETIME(), 'Job created at intake');
    END

    COMMIT TRAN;
    SELECT @NewJobId AS JobCardID;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH
END
GO
