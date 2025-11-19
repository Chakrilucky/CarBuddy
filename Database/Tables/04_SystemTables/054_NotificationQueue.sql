CREATE TABLE [dbo].[NotificationQueue](
	[QueueID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[JobCardID] [int] NULL,
	[TemplateID] [int] NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[DeliveryMode] [varchar](50) NOT NULL,
	[QueueStatus] [varchar](50) NOT NULL,
	[RetryCount] [int] NOT NULL,
	[ScheduledTime] [datetime2](7) NULL,
	[SentTime] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[FailureReason] [nvarchar](max) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
