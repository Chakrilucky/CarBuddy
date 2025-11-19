CREATE TABLE [dbo].[NotificationLog](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[JobCardID] [int] NULL,
	[NotificationType] [varchar](50) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[IsRead] [bit] NOT NULL,
	[ReadDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
