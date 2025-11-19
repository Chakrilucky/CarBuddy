CREATE TABLE [dbo].[InventoryPurchases](
	[PurchaseID] [int] IDENTITY(1,1) NOT NULL,
	[PartID] [int] NOT NULL,
	[VendorID] [int] NULL,
	[InvoiceNumber] [nvarchar](100) NULL,
	[PurchaseDate] [datetime2](7) NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[UnitCost] [decimal](10, 2) NOT NULL,
	[TotalCost]  AS ([Quantity]*[UnitCost]) PERSISTED,
	[GSTPercent] [decimal](5, 2) NULL,
	[GSTAmount] [decimal](10, 2) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PurchaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
