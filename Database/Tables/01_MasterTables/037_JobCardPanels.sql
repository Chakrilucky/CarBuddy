CREATE TABLE [dbo].[JobCardPanels](
	[JobCardPanelID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[PanelID] [int] NOT NULL,
	[BodyTypeID] [int] NOT NULL,
	[DentingCost] [decimal](14, 2) NULL,
	[PaintingCost] [decimal](14, 2) NULL,
	[TotalCost]  AS (isnull([DentingCost],(0))+isnull([PaintingCost],(0))),
	[IsCompleted] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobCardPanelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
