SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_CloseClaim]
(
    @ClaimSettlementID INT,
    @ClosedByUserID INT,
    @Remarks NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsuranceClaimID INT;

    -- Fetch the main Claim ID
    SELECT @InsuranceClaimID = InsuranceClaimID
    FROM InsuranceClaimSettlements
    WHERE ClaimSettlementID = @ClaimSettlementID
      AND BranchID = @BranchID;

    IF (@InsuranceClaimID IS NULL)
    BEGIN
        RAISERROR('Settlement not found or access denied.', 16, 1);
        RETURN;
    END;

    ------------------------------------
    -- 1️⃣ Update Settlement as CLOSED
    ------------------------------------
    UPDATE InsuranceClaimSettlements
    SET 
        Status = 'Closed',
        UpdatedDate = GETDATE()
    WHERE 
        ClaimSettlementID = @ClaimSettlementID
        AND BranchID = @BranchID;

    ------------------------------------
    -- 2️⃣ Update Main Insurance Claim
    ------------------------------------
    UPDATE InsuranceClaims
    SET 
        ClaimStatus = 'Closed',
        UpdatedDate = GETDATE()
    WHERE 
        InsuranceClaimID = @InsuranceClaimID
        AND BranchID = @BranchID;

    ------------------------------------
    -- 3️⃣ Insert into Status History
    ------------------------------------
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
        'Approved',        -- previous step
        'Closed',          -- now closed
        @ClosedByUserID,
        GETDATE(),
        @Remarks,
        @BranchID
    );

    SELECT 'Claim closed successfully.' AS Message;
END;

GO
