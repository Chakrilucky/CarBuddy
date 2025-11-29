-- sp_CreateHandoverRecord.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateHandoverRecord','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateHandoverRecord;
GO
CREATE PROCEDURE dbo.sp_CreateHandoverRecord
  @JobId INT = NULL,                    -- JobCardID (nullable)
  @HandoverName NVARCHAR(200),
  @Relationship NVARCHAR(100) = NULL,
  @Contact NVARCHAR(50) = NULL,
  @IdType NVARCHAR(50) = NULL,
  @IdPhotoPath NVARCHAR(500) = NULL,
  @IsOwnerPresent BIT = 0,
  @ConsentSignaturePath NVARCHAR(500) = NULL,
  @CreatedBy INT = NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.HandoverRecords (JobId, HandoverName, Relationship, Contact, IdType, IdPhotoPath, IsOwnerPresent, ConsentSignaturePath, HandoverTime)
  VALUES (@JobId, @HandoverName, @Relationship, @Contact, @IdType, @IdPhotoPath, @IsOwnerPresent, @ConsentSignaturePath, SYSUTCDATETIME());

  DECLARE @NewId INT = CONVERT(INT,SCOPE_IDENTITY());

  IF @JobId IS NOT NULL
  BEGIN
    IF OBJECT_ID('dbo.JobStatusHistory','U') IS NOT NULL
    BEGIN
      INSERT INTO dbo.JobStatusHistory (JobId, OldStatus, NewStatus, ChangedBy, ChangedAt, Comment)
      VALUES (@JobId, NULL, 'HandoverRecorded', @CreatedBy, SYSUTCDATETIME(), CONCAT('Handover recorded id=', @NewId));
    END

    UPDATE dbo.JobCards SET HandoverId = @NewId WHERE JobCardID = @JobId;
  END

  SELECT @NewId AS HandoverId;
END
GO
