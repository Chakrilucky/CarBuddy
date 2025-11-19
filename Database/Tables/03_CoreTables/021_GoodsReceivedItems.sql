CREATE TABLE [dbo].[GoodsReceivedItems](
	[GRNItemID] [int] IDENTITY(1,1) NOT NULL,
	[GRNID] [int] NOT NULL,
	[PartID] [int] NOT NULL,
	[QuantityReceived] [decimal](18, 2) NOT NULL,
	[UnitCost] [decimal](18, 2) NULL,
	[TotalCost]  AS ([QuantityReceived]*[UnitCost]) PERSISTED,
	[BranchID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GRNItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
