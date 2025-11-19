CREATE TABLE [dbo].[LoginHistory](
	[LoginID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[LoginTime] [datetime2](7) NOT NULL,
	[LogoutTime] [datetime2](7) NULL,
	[LoginStatus] [varchar](50) NOT NULL,
	[IPAddress] [varchar](50) NULL,
	[DeviceInfo] [nvarchar](200) NULL,
	[FailureReason] [nvarchar](300) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
