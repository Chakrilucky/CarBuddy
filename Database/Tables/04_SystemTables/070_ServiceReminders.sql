CREATE TABLE [dbo].[ServiceReminders](
	[ReminderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[JobCardID] [int] NULL,
	[ReminderType] [varchar](50) NOT NULL,
	[DueDate] [date] NOT NULL,
	[OdometerDue] [int] NULL,
	[ReminderStatus] [varchar](50) NOT NULL,
	[LastSentDate] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReminderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
