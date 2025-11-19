CREATE TABLE [dbo].[PanelPricing](
	[PricingID] [int] IDENTITY(1,1) NOT NULL,
	[PanelID] [int] NOT NULL,
	[BodyTypeID] [int] NOT NULL,
	[DentingCost] [decimal](14, 2) NOT NULL,
	[PaintingCost] [decimal](14, 2) NOT NULL,
	[IsFullBodyApplicable] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
