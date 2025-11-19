CREATE TABLE [dbo].[JobDiscounts](
	[JobDiscountID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[InvoiceID] [int] NULL,
	[DiscountID] [int] NOT NULL,
	[DiscountType] [varchar](50) NOT NULL,
	[DiscountValue] [decimal](10, 2) NOT NULL,
	[AppliedAmount] [decimal](14, 2) NOT NULL,
	[ApprovedByUserID] [int] NULL,
	[ApprovalDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobDiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
