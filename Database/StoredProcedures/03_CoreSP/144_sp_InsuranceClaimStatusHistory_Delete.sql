SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimStatusHistory_Delete]
(
    @StatusHistoryID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM InsuranceClaimStatusHistory
    WHERE StatusHistoryID = @StatusHistoryID;
END;

GO
