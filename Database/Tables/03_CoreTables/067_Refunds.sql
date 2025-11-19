CREATE TABLE [dbo].[Refunds](
	[RefundID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[InvoiceID] [int] NULL,
	[RefundAmount] [decimal](12, 2) NOT NULL,
	[RefundMode] [varchar](50) NOT NULL,
	[TransactionReference] [nvarchar](200) NULL,
	[RefundDate] [datetime2](7) NOT NULL,
	[RefundedByUserID] [int] NULL,
	[RefundReason] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RefundID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
