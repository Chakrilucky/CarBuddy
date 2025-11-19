CREATE TABLE [dbo].[ComplaintTickets](
	[ComplaintID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NULL,
	[CustomerID] [int] NOT NULL,
	[VehicleID] [int] NULL,
	[ComplaintTitle] [nvarchar](200) NOT NULL,
	[ComplaintDescription] [nvarchar](max) NOT NULL,
	[ComplaintCategory] [varchar](50) NOT NULL,
	[Priority] [varchar](50) NOT NULL,
	[ComplaintStatus] [varchar](50) NOT NULL,
	[AssignedToUserID] [int] NULL,
	[ReportedDate] [datetime2](7) NOT NULL,
	[ResolvedDate] [datetime2](7) NULL,
	[ResolutionRemarks] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
