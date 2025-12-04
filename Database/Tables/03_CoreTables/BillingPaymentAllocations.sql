-- =============================================
-- Table: BillingPaymentAllocations
-- Description: Links payments to invoices
-- =============================================

CREATE TABLE BillingPaymentAllocations (
    PaymentAllocationId  INT IDENTITY(1,1) PRIMARY KEY,
    PaymentId            INT NOT NULL,
    InvoiceId            INT NOT NULL,
    AllocatedAmount      DECIMAL(18,2) NOT NULL
);

ALTER TABLE BillingPaymentAllocations
    ADD CONSTRAINT FK_PaymentAllocations_Payments
    FOREIGN KEY (PaymentId) REFERENCES BillingPayments(PaymentId);

ALTER TABLE BillingPaymentAllocations
    ADD CONSTRAINT FK_PaymentAllocations_Invoices
    FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);
