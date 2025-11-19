CREATE TABLE [dbo].[TechnicianPerformanceLog](
	[PerformanceID] [int] IDENTITY(1,1) NOT NULL,
	[TechnicianID] [int] NOT NULL,
	[JobCardID] [int] NOT NULL,
	[WorkType] [varchar](50) NOT NULL,
	[LabourHours] [decimal](10, 2) NULL,
	[LabourPoints] [int] NULL,
	[QualityRating] [int] NULL,
	[ComebackFlag] [bit] NOT NULL,
	[PartsAccuracy] [bit] NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PerformanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
