CREATE TABLE [dbo].[TowingRequests](
	[TowingRequestID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[PickupLocation] [nvarchar](300) NOT NULL,
	[DropLocation] [nvarchar](300) NULL,
	[DistanceKM] [decimal](10, 2) NULL,
	[TowingCharge] [decimal](12, 2) NULL,
	[AssignedDriverID] [int] NULL,
	[AssignedVehicleID] [int] NULL,
	[RequestStatus] [varchar](50) NOT NULL,
	[RequestDate] [datetime2](7) NOT NULL,
	[CompletedDate] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TowingRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
