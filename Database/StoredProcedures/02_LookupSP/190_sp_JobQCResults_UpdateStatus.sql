SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobQCResults_UpdateStatus]
    @QCResultID INT,
    @QCStatus VARCHAR(20),
    @Remarks NVARCHAR(MAX),
    @CheckedByUserID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobQCResults
    SET
        QCStatus = @QCStatus,
        Remarks = @Remarks,
        CheckedByUserID = @CheckedByUserID,
        CheckedDate = GETDATE()
    WHERE QCResultID = @QCResultID
      AND BranchID = @BranchID;

    SELECT 'Updated' AS Status;
END;

GO
