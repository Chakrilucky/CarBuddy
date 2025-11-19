CREATE TABLE [dbo].[VendorPayments](
	[VendorPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[PurchaseID] [int] NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[AmountPaid] [decimal](10, 2) NOT NULL,
	[ReferenceNumber] [nvarchar](150) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
