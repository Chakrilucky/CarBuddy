SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_Update]
(
    @ClaimSettlementID INT,
    @TotalRequested DECIMAL(18,2),
    @TotalApproved DECIMAL(18,2),
    @CustomerPayable DECIMAL(18,2),
    @InsurancePayable DECIMAL(18,2),
    @Notes NVARCHAR(MAX) = NULL,
    @Status VARCHAR(50),       -- Pending / In-Progress / Finalized
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InsuranceClaimSettlements
    SET 
        TotalRequested = @TotalRequested,
        TotalApproved = @TotalApproved,
        CustomerPayable = @CustomerPayable,
        InsurancePayable = @InsurancePayable,
        Notes = @Notes,
        Status = @Status,
        UpdatedDate = GETDATE()
    WHERE 
        ClaimSettlementID = @ClaimSettlementID
        AND BranchID = @BranchID;
END;

GO
