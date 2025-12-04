-- =============================================
-- Table: BillingInvoiceItems
-- Description: Stores all line items of an invoice
-- Created On: 04-Dec-2025
-- =============================================

CREATE TABLE BillingInvoiceItems (
    InvoiceItemId        INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId            INT NOT NULL,
    JobCardId            INT NOT NULL,

    -- Type of item
    SourceType           VARCHAR(20) NOT NULL,
        -- Allowed: LABOUR, PART, MARKET_PART, ADDON

    SourceRefId          INT NULL,   -- Link to job/service/part reference

    -- What customer sees on invoice
    Description          NVARCHAR(200) NOT NULL,

    Quantity             DECIMAL(10,2) NOT NULL DEFAULT 1,
    UnitPrice            DECIMAL(18,2) NOT NULL DEFAULT 0,
    LineSubTotal         DECIMAL(18,2) NOT NULL DEFAULT 0,

    LineDiscountAmount   DECIMAL(18,2) NOT NULL DEFAULT 0,

    TaxPercent           DECIMAL(5,2) NOT NULL DEFAULT 0,
    TaxAmount            DECIMAL(18,2) NOT NULL DEFAULT 0,
    LineTotalAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- For future insurance cases (Phase-2 ready)
    CustomerPortionAmount   DECIMAL(18,2) NOT NULL DEFAULT 0,
    InsurancePortionAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,

    CreatedOn            DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

ALTER TABLE BillingInvoiceItems
    ADD CONSTRAINT FK_BillingInvoiceItems_Invoice
    FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);

-- This ensures only proper types are inserted
ALTER TABLE BillingInvoiceItems
    ADD CONSTRAINT CK_BillingInvoiceItems_SourceType
    CHECK (SourceType IN ('LABOUR','PART','MARKET_PART','ADDON'));
