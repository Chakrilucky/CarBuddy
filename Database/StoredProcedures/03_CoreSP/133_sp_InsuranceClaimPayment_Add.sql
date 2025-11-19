SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimPayment_Add]
(
    @InsuranceClaimID INT,
    @PaymentMethod VARCHAR(50),
    @AmountPaid DECIMAL(18,2),
    @TransactionReference NVARCHAR(200) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaimPayments
    (
        InsuranceClaimID,
        PaymentDate,
        PaymentMethod,
        AmountPaid,
        TransactionReference,
        Notes,
        CreatedDate,
        UpdatedDate,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        GETDATE(),
        @PaymentMethod,
        @AmountPaid,
        @TransactionReference,
        @Notes,
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewPaymentID;
END;

GO
