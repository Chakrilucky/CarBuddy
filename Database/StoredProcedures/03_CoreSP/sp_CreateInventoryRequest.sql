-- sp_CreateInventoryRequest.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateInventoryRequest','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateInventoryRequest;
GO
CREATE PROCEDURE dbo.sp_CreateInventoryRequest
  @JobId INT,
  @RequestedByUserId INT,
  @ItemsJson NVARCHAR(MAX),
  @Urgency NVARCHAR(50) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.InventoryRequests (JobId, RequestedByUserId, ItemsJson, Status, Urgency, RequestedAt)
  VALUES (@JobId, @RequestedByUserId, @ItemsJson, 'PENDING', @Urgency, SYSUTCDATETIME());

  SELECT CONVERT(INT,SCOPE_IDENTITY()) AS RequestId;
END
GO
