CREATE TABLE [dbo].[ExpensePayments](
	[ExpensePaymentID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseID] [int] NOT NULL,
	[AmountPaid] [decimal](14, 2) NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[PaymentMode] [varchar](50) NOT NULL,
	[TransactionReference] [nvarchar](200) NULL,
	[PaidByUserID] [int] NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpensePaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
