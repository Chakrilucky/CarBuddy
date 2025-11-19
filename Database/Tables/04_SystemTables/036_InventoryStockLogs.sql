CREATE TABLE [dbo].[InventoryStockLogs](
	[StockLogID] [int] IDENTITY(1,1) NOT NULL,
	[PartID] [int] NOT NULL,
	[JobCardID] [int] NULL,
	[PurchaseID] [int] NULL,
	[TransactionType] [varchar](50) NOT NULL,
	[Source] [varchar](100) NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[StockBefore] [decimal](10, 2) NULL,
	[StockAfter] [decimal](10, 2) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StockLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
