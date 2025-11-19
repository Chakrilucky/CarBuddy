CREATE TABLE [dbo].[AppointmentBookings](
	[BookingID] [int] IDENTITY(1,1) NOT NULL,
	[SlotID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NOT NULL,
	[PriorityTypeID] [int] NOT NULL,
	[BookingStatus] [varchar](50) NOT NULL,
	[HasTowing] [bit] NOT NULL,
	[TowingRequestID] [int] NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
