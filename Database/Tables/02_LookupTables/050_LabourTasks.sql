CREATE TABLE [dbo].[LabourTasks](
	[LabourTaskID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceTypeID] [int] NOT NULL,
	[TaskName] [nvarchar](200) NOT NULL,
	[DefaultHours] [decimal](10, 2) NULL,
	[DefaultRate] [decimal](10, 2) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LabourTaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
