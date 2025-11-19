CREATE TABLE [dbo].[AppNotificationsLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[NotificationID] [bigint] NULL,
	[DeviceToken] [nvarchar](500) NULL,
	[Platform] [varchar](50) NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[DeliveryStatus] [varchar](50) NOT NULL,
	[DeliveryDate] [datetime2](7) NOT NULL,
	[FailureReason] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
