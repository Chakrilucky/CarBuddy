SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_Get]
(
    @ClaimSettlementID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ClaimSettlementID,
        InsuranceClaimID,
        TotalRequested,
        TotalApproved,
        CustomerPayable,
        InsurancePayable,
        SettlementDate,
        Notes,
        Status,
        CreatedDate,
        UpdatedDate,
        BranchID
    FROM InsuranceClaimSettlements
    WHERE 
        ClaimSettlementID = @ClaimSettlementID
        AND BranchID = @BranchID;
END;

GO
