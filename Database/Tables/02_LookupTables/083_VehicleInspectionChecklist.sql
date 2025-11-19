CREATE TABLE [dbo].[VehicleInspectionChecklist](
	[InspectionID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[FuelLevel] [varchar](20) NULL,
	[OdometerReading] [int] NULL,
	[FrontLeftTyre] [nvarchar](50) NULL,
	[FrontRightTyre] [nvarchar](50) NULL,
	[RearLeftTyre] [nvarchar](50) NULL,
	[RearRightTyre] [nvarchar](50) NULL,
	[SpareTyre] [nvarchar](50) NULL,
	[ExteriorCondition] [nvarchar](max) NULL,
	[InteriorCondition] [nvarchar](max) NULL,
	[DashboardWarnings] [nvarchar](max) NULL,
	[HasToolKit] [bit] NOT NULL,
	[HasJack] [bit] NOT NULL,
	[HasFloorMats] [bit] NOT NULL,
	[HasMusicSystem] [bit] NOT NULL,
	[HasDashCam] [bit] NOT NULL,
	[RCReceived] [bit] NOT NULL,
	[InsurancePaperReceived] [bit] NOT NULL,
	[PollutionPaperReceived] [bit] NOT NULL,
	[PhotoPath1] [nvarchar](max) NULL,
	[PhotoPath2] [nvarchar](max) NULL,
	[PhotoPath3] [nvarchar](max) NULL,
	[PhotoPath4] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InspectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
