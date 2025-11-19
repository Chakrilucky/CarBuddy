CREATE TABLE [dbo].[TowingVehicles](
	[TowVehicleID] [int] IDENTITY(1,1) NOT NULL,
	[VehicleNumber] [varchar](20) NOT NULL,
	[VehicleModel] [nvarchar](150) NOT NULL,
	[VehicleType] [varchar](50) NOT NULL,
	[CapacityTons] [decimal](10, 2) NULL,
	[RCNumber] [nvarchar](50) NULL,
	[RCExpiry] [date] NULL,
	[InsuranceExpiry] [date] NULL,
	[PollutionExpiry] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TowVehicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[VehicleNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
