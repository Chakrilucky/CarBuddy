CREATE TABLE [dbo].[JobInvoices](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[InvoiceNumber] [varchar](30) NOT NULL,
	[InvoiceDate] [datetime2](7) NOT NULL,
	[SubTotal] [decimal](10, 2) NOT NULL,
	[DiscountAmount] [decimal](10, 2) NOT NULL,
	[TaxAmount] [decimal](10, 2) NOT NULL,
	[GrandTotal]  AS (([SubTotal]-[DiscountAmount])+[TaxAmount]) PERSISTED,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[InvoiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
