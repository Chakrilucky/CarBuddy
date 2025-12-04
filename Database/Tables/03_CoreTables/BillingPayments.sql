-- =============================================
-- Table: BillingPayments
-- Description: One row per payment (receipt)
-- =============================================

CREATE TABLE BillingPayments (
    PaymentId           INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptNumber       NVARCHAR(30) NOT NULL UNIQUE,   -- e.g. RCPT-2025-0001

    CustomerId          INT NOT NULL,
    PaymentDate         DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    PaymentMode         VARCHAR(20) NOT NULL,           -- CASH/UPI/CARD/BANK_TRANSFER/CHEQUE/OTHER
    ReferenceNumber     NVARCHAR(100) NULL,             -- UPI txn id, cheque no, etc.

    TotalPaymentAmount  DECIMAL(18,2) NOT NULL,

    Notes               NVARCHAR(200) NULL,

    CreatedBy           INT NULL,
    CreatedOn           DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

-- Optional FK (uncomment and adjust if your table name differs)
-- ALTER TABLE BillingPayments ADD CONSTRAINT FK_BillingPayments_Customers
--   FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId);

ALTER TABLE BillingPayments
    ADD CONSTRAINT CK_BillingPayments_Mode
    CHECK (PaymentMode IN ('CASH','UPI','CARD','BANK_TRANSFER','CHEQUE','OTHER'));
