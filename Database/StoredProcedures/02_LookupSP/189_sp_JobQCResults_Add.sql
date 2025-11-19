SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobQCResults_Add]
    @JobCardID INT,
    @QCItemID INT,
    @QCStatus VARCHAR(20),     -- Pass / Fail / NA
    @Remarks NVARCHAR(MAX),
    @CheckedByUserID INT,
    @PhotoPath NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobQCResults
    (
        JobCardID, QCItemID, QCStatus,
        Remarks, PhotoPath, CheckedByUserID,
        CheckedDate, CreatedDate, BranchID
    )
    VALUES
    (
        @JobCardID, @QCItemID, @QCStatus,
        @Remarks, @PhotoPath, @CheckedByUserID,
        GETDATE(), GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS QCResultID;
END;

GO
