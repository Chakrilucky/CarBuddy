CREATE TABLE [dbo].[Branches](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[BranchName] [nvarchar](200) NOT NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[AddressLine1] [nvarchar](200) NULL,
	[AddressLine2] [nvarchar](200) NULL,
	[Pincode] [nvarchar](20) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Email] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
