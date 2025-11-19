CREATE TABLE [dbo].[FollowUpCalls](
	[FollowUpID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NULL,
	[JobCardID] [int] NULL,
	[ReminderID] [int] NULL,
	[FollowUpReason] [varchar](100) NOT NULL,
	[CallStatus] [varchar](50) NOT NULL,
	[CallDate] [datetime2](7) NULL,
	[NextFollowUpDate] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CalledByUserID] [int] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[FollowUpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
