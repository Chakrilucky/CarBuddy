CREATE TABLE [dbo].[Expenses](
	[ExpenseID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Amount] [decimal](14, 2) NOT NULL,
	[ExpenseDate] [date] NOT NULL,
	[PaidByUserID] [int] NULL,
	[PaymentMode] [varchar](50) NOT NULL,
	[VendorName] [nvarchar](200) NULL,
	[BillNumber] [nvarchar](100) NULL,
	[BillPhoto] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpenseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
