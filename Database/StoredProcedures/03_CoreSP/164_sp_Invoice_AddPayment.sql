SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Invoice_AddPayment]
(
    @InvoiceID INT,
    @JobCardID INT,
    @Amount DECIMAL(18,2),
    @PaymentMethod VARCHAR(50),
    @ReferenceNumber NVARCHAR(150) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Payments
    (
        JobCardID,
        InvoiceID,
        AmountPaid,
        PaymentMode,
        TransactionReference,
        PaymentDate,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @JobCardID,
        @InvoiceID,
        @Amount,
        @PaymentMethod,
        @ReferenceNumber,
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    EXEC sp_Invoice_CheckFullyPaid @InvoiceID;
END;

GO
