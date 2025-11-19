CREATE TABLE [dbo].[ServiceBays](
	[BayID] [int] IDENTITY(1,1) NOT NULL,
	[BayName] [nvarchar](100) NOT NULL,
	[BayType] [varchar](50) NOT NULL,
	[IsAvailable] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
