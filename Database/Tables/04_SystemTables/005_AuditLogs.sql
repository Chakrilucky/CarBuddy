CREATE TABLE [dbo].[AuditLogs](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[ActionType] [varchar](100) NOT NULL,
	[TableName] [varchar](200) NULL,
	[RecordID] [nvarchar](100) NULL,
	[ActionDescription] [nvarchar](max) NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[ActionDate] [datetime2](7) NOT NULL,
	[IPAddress] [varchar](50) NULL,
	[DeviceInfo] [nvarchar](300) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
