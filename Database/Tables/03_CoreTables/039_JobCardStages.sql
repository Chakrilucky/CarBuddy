CREATE TABLE [dbo].[JobCardStages](
	[JobCardStageId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobCardId] [bigint] NOT NULL,
	[StageOrder] [int] NOT NULL,
	[StageName] [varchar](100) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[BranchID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[JobCardStageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
