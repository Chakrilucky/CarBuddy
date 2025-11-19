CREATE TABLE [dbo].[PartUsageTracking](
	[UsageID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[PartID] [int] NOT NULL,
	[QuantityUsed] [decimal](10, 2) NOT NULL,
	[UnitPrice] [decimal](12, 2) NULL,
	[TotalPrice]  AS ([QuantityUsed]*[UnitPrice]) PERSISTED,
	[UsedByTechnicianID] [int] NULL,
	[UsageDate] [datetime2](7) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
