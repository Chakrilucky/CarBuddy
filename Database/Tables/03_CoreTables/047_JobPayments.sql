CREATE TABLE [dbo].[JobPayments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
	[ReferenceNumber] [nvarchar](150) NULL,
	[Notes] [nvarchar](max) NULL,
	[IsAdvance] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
