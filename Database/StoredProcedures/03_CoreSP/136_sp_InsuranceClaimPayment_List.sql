SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimPayment_List]
(
    @InsuranceClaimID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ClaimPaymentID,
        p.InsuranceClaimID,
        p.PaymentDate,
        p.PaymentMethod,
        p.AmountPaid,
        p.TransactionReference,
        p.Notes,
        p.CreatedDate,
        p.UpdatedDate,
        p.BranchID
    FROM InsuranceClaimPayments p
    WHERE 
        p.InsuranceClaimID = @InsuranceClaimID
        AND p.BranchID = @BranchID
    ORDER BY p.PaymentDate DESC, p.ClaimPaymentID DESC;
END;

GO
