SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimStatusHistory_List]
(
    @InsuranceClaimID INT = NULL,
    @BranchID         INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        h.StatusHistoryID,
        h.InsuranceClaimID,
        h.OldStatus,
        h.NewStatus,
        h.ChangedByUserID,
        u.FullName AS ChangedByUserName,
        h.ChangeDate,
        h.Remarks,
        h.BranchID
    FROM InsuranceClaimStatusHistory h
    LEFT JOIN Users u ON h.ChangedByUserID = u.UserID
    WHERE
        (@InsuranceClaimID IS NULL OR h.InsuranceClaimID = @InsuranceClaimID)
        AND (@BranchID IS NULL OR h.BranchID = @BranchID)
    ORDER BY h.ChangeDate DESC;
END;

GO
