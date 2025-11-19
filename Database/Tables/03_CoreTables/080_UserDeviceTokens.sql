CREATE TABLE [dbo].[UserDeviceTokens](
	[TokenID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[DeviceToken] [nvarchar](500) NOT NULL,
	[Platform] [varchar](50) NOT NULL,
	[LastUsedDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
