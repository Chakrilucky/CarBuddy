CREATE TABLE [dbo].[JobCards](
	[JobCardID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[ServiceTypeID] [int] NOT NULL,
	[PriorityTypeID] [int] NOT NULL,
	[JobCardNumber] [varchar](30) NOT NULL,
	[OdometerReading] [int] NULL,
	[FuelLevel] [varchar](20) NULL,
	[HasTowing] [bit] NOT NULL,
	[TowingNotes] [nvarchar](300) NULL,
	[EstimatedDelivery] [datetime2](7) NULL,
	[ActualDelivery] [datetime2](7) NULL,
	[JobStatus] [varchar](50) NOT NULL,
	[AssignedTechnicianID] [int] NULL,
	[Remarks] [nvarchar](max) NULL,
	[InsuranceClaimID] [int] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[CompletedOn] [datetime] NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[JobCardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
