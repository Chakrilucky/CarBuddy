SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_List]
(
    @InsuranceClaimID INT = NULL,   -- optional filter
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        S.ClaimSettlementID,
        S.InsuranceClaimID,
        S.TotalRequested,
        S.TotalApproved,
        S.CustomerPayable,
        S.InsurancePayable,
        S.SettlementDate,
        S.Notes,
        S.Status,
        S.CreatedDate,
        S.UpdatedDate,
        S.BranchID
    FROM InsuranceClaimSettlements S
    WHERE
        S.BranchID = @BranchID
        AND (@InsuranceClaimID IS NULL OR S.InsuranceClaimID = @InsuranceClaimID)
    ORDER BY
        S.SettlementDate DESC, 
        S.ClaimSettlementID DESC;
END;

GO
