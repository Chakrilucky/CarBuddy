SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimPayment_Get]
(
    @ClaimPaymentID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ClaimPaymentID,
        InsuranceClaimID,
        PaymentDate,
        PaymentMethod,
        AmountPaid,
        TransactionReference,
        Notes,
        CreatedDate,
        UpdatedDate,
        BranchID
    FROM InsuranceClaimPayments
    WHERE ClaimPaymentID = @ClaimPaymentID;
END;

GO
