CREATE TABLE [dbo].[DiscountRules](
	[DiscountID] [int] IDENTITY(1,1) NOT NULL,
	[DiscountName] [nvarchar](150) NOT NULL,
	[DiscountType] [varchar](50) NOT NULL,
	[DiscountValue] [decimal](10, 2) NOT NULL,
	[ApplicableOn] [varchar](50) NOT NULL,
	[RequireManagerApproval] [bit] NOT NULL,
	[MaxLimit] [decimal](14, 2) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DiscountName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
