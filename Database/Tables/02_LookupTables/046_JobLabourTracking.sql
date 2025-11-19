CREATE TABLE [dbo].[JobLabourTracking](
	[LabourID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[TechnicianID] [int] NOT NULL,
	[LabourType] [varchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[LabourHours] [decimal](10, 2) NULL,
	[LabourRate] [decimal](12, 2) NULL,
	[TotalLabourCost]  AS ([LabourHours]*[LabourRate]) PERSISTED,
	[WorkStatus] [varchar](50) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LabourID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
