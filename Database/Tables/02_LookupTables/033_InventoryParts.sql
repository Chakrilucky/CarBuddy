CREATE TABLE [dbo].[InventoryParts](
	[PartID] [int] IDENTITY(1,1) NOT NULL,
	[PartName] [nvarchar](200) NOT NULL,
	[PartCode] [nvarchar](100) NULL,
	[PartType] [varchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Unit] [nvarchar](50) NOT NULL,
	[HSNCode] [nvarchar](20) NULL,
	[CostPrice] [decimal](10, 2) NOT NULL,
	[SellingPrice] [decimal](10, 2) NOT NULL,
	[StockQuantity] [decimal](10, 2) NOT NULL,
	[ReorderLevel] [decimal](10, 2) NOT NULL,
	[VendorID] [int] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PartCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
