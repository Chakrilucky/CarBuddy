SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimStatusHistory_Add]
(
    @InsuranceClaimID   INT,
    @OldStatus          VARCHAR(50),
    @NewStatus          VARCHAR(50),
    @ChangedByUserID    INT,
    @Remarks            NVARCHAR(200),
    @BranchID           INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaimStatusHistory
    (
        InsuranceClaimID,
        OldStatus,
        NewStatus,
        ChangedByUserID,
        ChangeDate,
        Remarks,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        @OldStatus,
        @NewStatus,
        @ChangedByUserID,
        GETDATE(),
        @Remarks,
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewStatusHistoryID;
END;

GO
