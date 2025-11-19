CREATE TABLE [dbo].[JobInvoiceItems](
	[InvoiceItemID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[ItemType] [varchar](50) NOT NULL,
	[ItemName] [nvarchar](200) NOT NULL,
	[ItemDescription] [nvarchar](max) NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[TotalPrice]  AS ([Quantity]*[UnitPrice]) PERSISTED,
	[IsTaxable] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
