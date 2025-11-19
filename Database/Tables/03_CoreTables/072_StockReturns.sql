CREATE TABLE [dbo].[StockReturns](
	[ReturnID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[PurchaseID] [int] NULL,
	[PartID] [int] NOT NULL,
	[QuantityReturned] [decimal](18, 2) NOT NULL,
	[ReturnReason] [nvarchar](max) NULL,
	[ReturnDate] [datetime2](7) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReturnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
