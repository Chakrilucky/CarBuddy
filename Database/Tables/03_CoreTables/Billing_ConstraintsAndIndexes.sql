/* ============================================
   PHASE-1 BILLING – FKs, CHECKS, INDEXES
   Safe to run multiple times
   ============================================ */

------------------------------------------------
-- 1. FOREIGN KEYS
------------------------------------------------

-- 1.1 BillingInvoices -> JobCards
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BillingInvoices_JobCards'
)
BEGIN
    ALTER TABLE BillingInvoices WITH CHECK
    ADD CONSTRAINT FK_BillingInvoices_JobCards
    FOREIGN KEY (JobCardId) REFERENCES JobCards(JobCardId);
END
GO

-- 1.2 BillingInvoices -> Customers
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BillingInvoices_Customers'
)
BEGIN
    ALTER TABLE BillingInvoices WITH CHECK
    ADD CONSTRAINT FK_BillingInvoices_Customers
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId);
END
GO

-- 1.3 BillingInvoiceItems -> BillingInvoices
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BillingInvoiceItems_Invoices'
)
BEGIN
    ALTER TABLE BillingInvoiceItems WITH CHECK
    ADD CONSTRAINT FK_BillingInvoiceItems_Invoices
    FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);
END
GO

-- 1.4 BillingInvoiceItems -> JobCards
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BillingInvoiceItems_JobCards'
)
BEGIN
    ALTER TABLE BillingInvoiceItems WITH CHECK
    ADD CONSTRAINT FK_BillingInvoiceItems_JobCards
    FOREIGN KEY (JobCardId) REFERENCES JobCards(JobCardId);
END
GO

-- 1.5 BillingPayments -> Customers
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BillingPayments_Customers'
)
BEGIN
    ALTER TABLE BillingPayments WITH CHECK
    ADD CONSTRAINT FK_BillingPayments_Customers
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId);
END
GO

-- 1.6 BillingPaymentAllocations -> BillingPayments
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_PaymentAllocations_Payments'
)
BEGIN
    ALTER TABLE BillingPaymentAllocations WITH CHECK
    ADD CONSTRAINT FK_PaymentAllocations_Payments
    FOREIGN KEY (PaymentId) REFERENCES BillingPayments(PaymentId);
END
GO

-- 1.7 BillingPaymentAllocations -> BillingInvoices
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_PaymentAllocations_Invoices'
)
BEGIN
    ALTER TABLE BillingPaymentAllocations WITH CHECK
    ADD CONSTRAINT FK_PaymentAllocations_Invoices
    FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);
END
GO

-- 1.8 JobMarketPurchases -> JobCards
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_JobMarketPurchases_JobCards'
)
BEGIN
    ALTER TABLE JobMarketPurchases WITH CHECK
    ADD CONSTRAINT FK_JobMarketPurchases_JobCards
    FOREIGN KEY (JobCardId) REFERENCES JobCards(JobCardId);
END
GO

-- 1.9 JobMarketPurchaseItems -> JobMarketPurchases
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_JobMarketPurchaseItems_Header'
)
BEGIN
    ALTER TABLE JobMarketPurchaseItems WITH CHECK
    ADD CONSTRAINT FK_JobMarketPurchaseItems_Header
    FOREIGN KEY (MarketPurchaseId) REFERENCES JobMarketPurchases(MarketPurchaseId);
END
GO

-- 1.10 JobMarketPurchaseItems -> BillingInvoices (optional link)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_JobMarketPurchaseItems_Invoices'
)
BEGIN
    ALTER TABLE JobMarketPurchaseItems WITH CHECK
    ADD CONSTRAINT FK_JobMarketPurchaseItems_Invoices
    FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);
END
GO


------------------------------------------------
-- 2. CHECK CONSTRAINTS
------------------------------------------------

-- BillingInvoiceItems quantity > 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingInvoiceItems_Quantity_Positive'
)
BEGIN
    ALTER TABLE BillingInvoiceItems
    ADD CONSTRAINT CK_BillingInvoiceItems_Quantity_Positive
    CHECK (Quantity > 0);
END
GO

-- BillingInvoiceItems UnitPrice >= 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingInvoiceItems_UnitPrice_NonNegative'
)
BEGIN
    ALTER TABLE BillingInvoiceItems
    ADD CONSTRAINT CK_BillingInvoiceItems_UnitPrice_NonNegative
    CHECK (UnitPrice >= 0);
END
GO

-- BillingInvoiceItems TaxPercent >= 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingInvoiceItems_TaxPercent_NonNegative'
)
BEGIN
    ALTER TABLE BillingInvoiceItems
    ADD CONSTRAINT CK_BillingInvoiceItems_TaxPercent_NonNegative
    CHECK (TaxPercent >= 0);
END
GO

-- BillingInvoices TotalInvoiceAmount >= 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingInvoices_TotalInvoiceAmount_NonNegative'
)
BEGIN
    ALTER TABLE BillingInvoices
    ADD CONSTRAINT CK_BillingInvoices_TotalInvoiceAmount_NonNegative
    CHECK (TotalInvoiceAmount >= 0);
END
GO

-- BillingInvoices DiscountAmount >= 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingInvoices_DiscountAmount_NonNegative'
)
BEGIN
    ALTER TABLE BillingInvoices
    ADD CONSTRAINT CK_BillingInvoices_DiscountAmount_NonNegative
    CHECK (DiscountAmount >= 0);
END
GO

-- BillingPayments TotalPaymentAmount > 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_BillingPayments_Amount_Positive'
)
BEGIN
    ALTER TABLE BillingPayments
    ADD CONSTRAINT CK_BillingPayments_Amount_Positive
    CHECK (TotalPaymentAmount > 0);
END
GO

-- BillingPaymentAllocations AllocatedAmount > 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_PaymentAllocations_Amount_Positive'
)
BEGIN
    ALTER TABLE BillingPaymentAllocations
    ADD CONSTRAINT CK_PaymentAllocations_Amount_Positive
    CHECK (AllocatedAmount > 0);
END
GO

-- JobMarketPurchaseItems Quantity > 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_JobMarketPurchaseItems_Quantity_Positive'
)
BEGIN
    ALTER TABLE JobMarketPurchaseItems
    ADD CONSTRAINT CK_JobMarketPurchaseItems_Quantity_Positive
    CHECK (Quantity > 0);
END
GO

-- JobMarketPurchaseItems UnitCost >= 0
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CK_JobMarketPurchaseItems_UnitCost_NonNegative'
)
BEGIN
    ALTER TABLE JobMarketPurchaseItems
    ADD CONSTRAINT CK_JobMarketPurchaseItems_UnitCost_NonNegative
    CHECK (UnitCost >= 0);
END
GO


------------------------------------------------
-- 3. INDEXES FOR PERFORMANCE
------------------------------------------------

-- BillingInvoices indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoices_JobCardId')
BEGIN
    CREATE INDEX IX_BillingInvoices_JobCardId
        ON BillingInvoices (JobCardId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoices_CustomerId')
BEGIN
    CREATE INDEX IX_BillingInvoices_CustomerId
        ON BillingInvoices (CustomerId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoices_Status')
BEGIN
    CREATE INDEX IX_BillingInvoices_Status
        ON BillingInvoices (Status);
END
GO


-- BillingInvoiceItems indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoiceItems_InvoiceId')
BEGIN
    CREATE INDEX IX_BillingInvoiceItems_InvoiceId
        ON BillingInvoiceItems (InvoiceId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoiceItems_JobCardId')
BEGIN
    CREATE INDEX IX_BillingInvoiceItems_JobCardId
        ON BillingInvoiceItems (JobCardId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingInvoiceItems_SourceType')
BEGIN
    CREATE INDEX IX_BillingInvoiceItems_SourceType
        ON BillingInvoiceItems (SourceType);
END
GO


-- BillingPayments indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingPayments_CustomerId')
BEGIN
    CREATE INDEX IX_BillingPayments_CustomerId
        ON BillingPayments (CustomerId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BillingPayments_PaymentDate')
BEGIN
    CREATE INDEX IX_BillingPayments_PaymentDate
        ON BillingPayments (PaymentDate);
END
GO


-- BillingPaymentAllocations indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PaymentAllocations_PaymentId')
BEGIN
    CREATE INDEX IX_PaymentAllocations_PaymentId
        ON BillingPaymentAllocations (PaymentId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PaymentAllocations_InvoiceId')
BEGIN
    CREATE INDEX IX_PaymentAllocations_InvoiceId
        ON BillingPaymentAllocations (InvoiceId);
END
GO


-- JobMarketPurchases index
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JobMarketPurchases_JobCardId')
BEGIN
    CREATE INDEX IX_JobMarketPurchases_JobCardId
        ON JobMarketPurchases (JobCardId);
END
GO


-- JobMarketPurchaseItems indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JobMarketPurchaseItems_MarketPurchaseId')
BEGIN
    CREATE INDEX IX_JobMarketPurchaseItems_MarketPurchaseId
        ON JobMarketPurchaseItems (MarketPurchaseId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JobMarketPurchaseItems_InvoiceId')
BEGIN
    CREATE INDEX IX_JobMarketPurchaseItems_InvoiceId
        ON JobMarketPurchaseItems (InvoiceId);
END
GO
