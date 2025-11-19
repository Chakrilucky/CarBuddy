SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardMessages_Add]
    @JobCardID INT,
    @MessageText NVARCHAR(MAX),
    @SentByUserID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobCardMessages
    (
        JobCardID, MessageText, SentByUserID,
        SentDate, BranchID
    )
    VALUES
    (
        @JobCardID, @MessageText, @SentByUserID,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS MessageID;
END;

GO
