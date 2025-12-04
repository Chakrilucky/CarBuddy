-- =============================================
-- Table: JobMarketPurchaseItems
-- Description: Items inside a market purchase bill
-- =============================================

CREATE TABLE JobMarketPurchaseItems (
    MarketPurchaseItemId INT IDENTITY(1,1) PRIMARY KEY,
    MarketPurchaseId     INT NOT NULL,

    PartName             NVARCHAR(150) NOT NULL,
    PartNumber           NVARCHAR(50) NULL,

    Quantity             DECIMAL(10,2) NOT NULL DEFAULT 1,
    UnitCost             DECIMAL(18,2) NOT NULL DEFAULT 0,   -- your cost from shop
    LineTotalCost        DECIMAL(18,2) NOT NULL DEFAULT 0,

    IsBillableToCustomer BIT NOT NULL DEFAULT 1,

    -- When added to invoice, we link here
    InvoiceId            INT NULL,

    SellingPricePerUnit  DECIMAL(18,2) NOT NULL DEFAULT 0,   -- what you charge customer
    SellingLineTotal     DECIMAL(18,2) NOT NULL DEFAULT 0,

    CreatedOn            DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

ALTER TABLE JobMarketPurchaseItems
    ADD CONSTRAINT FK_JobMarketPurchaseItems_Header
    FOREIGN KEY (MarketPurchaseId) REFERENCES JobMarketPurchases(MarketPurchaseId);

-- Optional FK if you want strong link to invoice:
-- ALTER TABLE JobMarketPurchaseItems
--     ADD CONSTRAINT FK_JobMarketPurchaseItems_Invoice
--     FOREIGN KEY (InvoiceId) REFERENCES BillingInvoices(InvoiceId);
