CREATE TABLE [dbo].[EmployeeAttendance](
	[AttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[CheckInTime] [datetime2](7) NULL,
	[CheckOutTime] [datetime2](7) NULL,
	[AttendanceStatus] [varchar](20) NOT NULL,
	[TotalWorkingHours]  AS (case when [CheckInTime] IS NOT NULL AND [CheckOutTime] IS NOT NULL then datediff(minute,[CheckInTime],[CheckOutTime])/(60.0) else (0) end) PERSISTED,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AttendanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
