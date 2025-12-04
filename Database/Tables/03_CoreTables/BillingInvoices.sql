-- =============================================
-- Table: BillingInvoices
-- Description: Stores invoice header information
-- Created On: 04-Dec-2025
-- =============================================

CREATE TABLE BillingInvoices (
    InvoiceId            INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceNumber        NVARCHAR(30) NOT NULL UNIQUE,   -- e.g. CB-2025-0001
    JobCardId            INT NOT NULL,
    CustomerId           INT NOT NULL,
    InvoiceDate          DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    DueDate              DATETIME2 NULL,

    -- Amount breakup
    LabourSubTotal       DECIMAL(18,2) NOT NULL DEFAULT 0,
    PartsSubTotal        DECIMAL(18,2) NOT NULL DEFAULT 0,
    MarketPartsSubTotal  DECIMAL(18,2) NOT NULL DEFAULT 0,
    AddOnSubTotal        DECIMAL(18,2) NOT NULL DEFAULT 0,

    SubTotalBeforeDiscount DECIMAL(18,2) NOT NULL DEFAULT 0,
    DiscountAmount       DECIMAL(18,2) NOT NULL DEFAULT 0,
    DiscountReason       NVARCHAR(200) NULL,
    SubTotalAfterDiscount DECIMAL(18,2) NOT NULL DEFAULT 0,

    TaxPercent           DECIMAL(5,2) NOT NULL DEFAULT 18.00,
    CGSTAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    SGSTAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,
    IGSTAmount           DECIMAL(18,2) NOT NULL DEFAULT 0,

    TotalInvoiceAmount   DECIMAL(18,2) NOT NULL DEFAULT 0,

    TotalPaidAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    BalanceAmount        DECIMAL(18,2) NOT NULL DEFAULT 0,

    Status VARCHAR(20) NOT NULL
        CONSTRAINT CK_BillingInvoices_Status
        CHECK (Status IN ('DRAFT','FINAL','CANCELLED')),

    CreatedBy            INT NULL,
    CreatedOn            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedBy            INT NULL,
    UpdatedOn            DATETIME2 NULL
);

-- Add your FKs after you create the JobCards and Customers table
-- ALTER TABLE BillingInvoices ADD CONSTRAINT FK_BillingInvoices_JobCards
--   FOREIGN KEY (JobCardId) REFERENCES JobCards(JobCardId);

-- ALTER TABLE BillingInvoices ADD CONSTRAINT FK_BillingInvoices_Customers
--   FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId);
