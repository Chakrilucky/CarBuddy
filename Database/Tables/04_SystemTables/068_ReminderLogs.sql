CREATE TABLE [dbo].[ReminderLogs](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReminderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[DeliveryMode] [varchar](50) NOT NULL,
	[DeliveryStatus] [varchar](50) NOT NULL,
	[AttemptDate] [datetime2](7) NOT NULL,
	[FailureReason] [nvarchar](max) NULL,
	[RetryCount] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
