CREATE TABLE [dbo].[CustomerFeedback](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[ServiceQualityRating] [int] NULL,
	[CommunicationRating] [int] NULL,
	[DeliveryTimeRating] [int] NULL,
	[PricingRating] [int] NULL,
	[FeedbackText] [nvarchar](max) NULL,
	[Suggestions] [nvarchar](max) NULL,
	[TechnicianID] [int] NULL,
	[ReviewedByManager] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
