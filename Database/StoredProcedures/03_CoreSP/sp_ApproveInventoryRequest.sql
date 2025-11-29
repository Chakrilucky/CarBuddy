-- sp_ApproveInventoryRequest.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_ApproveInventoryRequest','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_ApproveInventoryRequest;
GO
CREATE PROCEDURE dbo.sp_ApproveInventoryRequest
  @RequestId INT,
  @ApprovedBy INT,
  @MarkAsExternal BIT = 0
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.InventoryRequests
    SET Status = CASE WHEN @MarkAsExternal = 1 THEN 'APPROVED_EXTERNAL' ELSE 'APPROVED' END,
        ApprovedBy = @ApprovedBy,
        ApprovedAt = SYSUTCDATETIME()
  WHERE RequestId = @RequestId;

  SELECT 1 AS Success, @RequestId AS RequestId;
END
GO
