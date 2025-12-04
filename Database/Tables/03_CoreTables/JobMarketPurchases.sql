-- =============================================
-- Table: JobMarketPurchases
-- Description: Header for external parts bills (market purchases)
-- =============================================

CREATE TABLE JobMarketPurchases (
    MarketPurchaseId     INT IDENTITY(1,1) PRIMARY KEY,
    JobCardId            INT NOT NULL,

    VendorName           NVARCHAR(100) NOT NULL,
    BillNumber           NVARCHAR(50) NULL,
    BillDate             DATE NULL,
    TotalBillAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,

    BillScanFilePath     NVARCHAR(260) NULL,  -- path or URL of scanned bill
    Notes                NVARCHAR(200) NULL,

    CreatedBy            INT NULL,
    CreatedOn            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ApprovedBy           INT NULL,
    ApprovedOn           DATETIME2 NULL
);

-- Optional FK (adjust JobCards table name if needed)
-- ALTER TABLE JobMarketPurchases ADD CONSTRAINT FK_JobMarketPurchases_JobCards
--   FOREIGN KEY (JobCardId) REFERENCES JobCards(JobCardId);
