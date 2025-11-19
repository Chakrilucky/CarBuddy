CREATE TABLE [dbo].[AppointmentStatusHistory](
	[StatusHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL,
	[OldStatus] [varchar](50) NULL,
	[NewStatus] [varchar](50) NOT NULL,
	[ChangedByUserID] [int] NULL,
	[ChangeDate] [datetime2](7) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
