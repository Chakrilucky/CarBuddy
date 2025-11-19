CREATE TABLE [dbo].[VehicleVisitHistory](
	[VisitID] [int] IDENTITY(1,1) NOT NULL,
	[VehicleID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[JobCardID] [int] NULL,
	[VisitType] [varchar](50) NOT NULL,
	[VisitDate] [datetime2](7) NOT NULL,
	[OdometerReading] [int] NULL,
	[Complaints] [nvarchar](max) NULL,
	[Observations] [nvarchar](max) NULL,
	[AttendedByUserID] [int] NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VisitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
