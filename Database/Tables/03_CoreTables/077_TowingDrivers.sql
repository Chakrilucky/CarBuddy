CREATE TABLE [dbo].[TowingDrivers](
	[DriverID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[MobileNumber] [varchar](15) NOT NULL,
	[AlternateNumber] [varchar](15) NULL,
	[LicenseNumber] [nvarchar](50) NULL,
	[LicenseExpiry] [date] NULL,
	[Address] [nvarchar](300) NULL,
	[ExperienceYears] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DriverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MobileNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
