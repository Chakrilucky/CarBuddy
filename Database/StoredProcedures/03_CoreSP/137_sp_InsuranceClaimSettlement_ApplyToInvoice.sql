SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_ApplyToInvoice]
(
    @ClaimSettlementID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @InsuranceClaimID INT,
        @JobCardID INT,
        @InvoiceID INT,
        @CustomerPayable DECIMAL(18,2),
        @InsurancePayable DECIMAL(18,2),
        @PendingAmount DECIMAL(18,2),
        @NewPendingAmount DECIMAL(18,2);

    ----------------------------------------------------
    -- 1️⃣ Get Claim → Settlement → JobCard → Invoice
    ----------------------------------------------------

    SELECT 
        @InsuranceClaimID = InsuranceClaimID,
        @CustomerPayable = CustomerPayable,
        @InsurancePayable = InsurancePayable
    FROM InsuranceClaimSettlements
    WHERE ClaimSettlementID = @ClaimSettlementID
      AND BranchID = @BranchID;

    IF @InsuranceClaimID IS NULL
    BEGIN
        RAISERROR('Settlement not found or access denied.', 16, 1);
        RETURN;
    END;

    SELECT @JobCardID = JobCardID 
    FROM InsuranceClaims
    WHERE InsuranceClaimID = @InsuranceClaimID
      AND BranchID = @BranchID;

    IF @JobCardID IS NULL
    BEGIN
        RAISERROR('JobCard not linked with insurance claim.', 16, 1);
        RETURN;
    END;

    SELECT @InvoiceID = InvoiceID,
           @PendingAmount = PendingAmount
    FROM Invoices
    WHERE JobCardID = @JobCardID
      AND BranchID = @BranchID;

    IF @InvoiceID IS NULL
    BEGIN
        RAISERROR('Invoice not found for JobCard.', 16, 1);
        RETURN;
    END;

    ----------------------------------------------------
    -- 2️⃣ Calculate new pending amount
    ----------------------------------------------------

    -- Customer pays their amount (CustomerPayable)
    -- Insurance covers InsurancePayable
    SET @NewPendingAmount = @PendingAmount - (@CustomerPayable + @InsurancePayable);

    IF @NewPendingAmount < 0 
        SET @NewPendingAmount = 0;

    ----------------------------------------------------
    -- 3️⃣ Update Invoice
    ----------------------------------------------------

    UPDATE Invoices
    SET 
        PaidAmount = PaidAmount + (@CustomerPayable + @InsurancePayable),
        PendingAmount = @NewPendingAmount,
        PaymentStatus = CASE 
                           WHEN @NewPendingAmount = 0 THEN 'Paid' 
                           ELSE 'Partially Paid' 
                        END,
        UpdatedDate = GETDATE()
    WHERE InvoiceID = @InvoiceID
      AND BranchID = @BranchID;

    ----------------------------------------------------
    -- 4️⃣ Mark Settlement as Applied
    ----------------------------------------------------

    UPDATE InsuranceClaimSettlements
    SET 
        Status = 'AppliedToInvoice',
        UpdatedDate = GETDATE()
    WHERE ClaimSettlementID = @ClaimSettlementID
      AND BranchID = @BranchID;

    ----------------------------------------------------
    -- 5️⃣ Update Claim Status
    ----------------------------------------------------

    UPDATE InsuranceClaims
    SET 
        ClaimStatus = 'Settled',
        UpdatedDate = GETDATE()
    WHERE InsuranceClaimID = @InsuranceClaimID
      AND BranchID = @BranchID;

    ----------------------------------------------------
    -- 6️⃣ Add Status History
    ----------------------------------------------------

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
        'Approved',
        'Settled',
        1,
        GETDATE(),
        'Insurance claim settlement applied to invoice.',
        @BranchID
    );

    ----------------------------------------------------
    -- 7️⃣ Return Response
    ----------------------------------------------------

    SELECT 
        'Settlement successfully applied to invoice.' AS Message,
        @InvoiceID AS InvoiceID,
        @NewPendingAmount AS FinalPendingAmount;
END;

GO
