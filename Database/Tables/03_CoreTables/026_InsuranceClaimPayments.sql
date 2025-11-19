CREATE TABLE [dbo].[InsuranceClaimPayments](
	[ClaimPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[AmountPaid] [decimal](12, 2) NOT NULL,
	[TransactionReference] [nvarchar](200) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
