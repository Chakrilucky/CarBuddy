CREATE TABLE [dbo].[AppointmentSlots](
	[SlotID] [int] IDENTITY(1,1) NOT NULL,
	[SlotDate] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[Capacity] [int] NOT NULL,
	[BookedCount] [int] NOT NULL,
	[SlotStatus] [varchar](50) NOT NULL,
	[IsPremiumSlot] [bit] NOT NULL,
	[Notes] [nvarchar](300) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SlotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
