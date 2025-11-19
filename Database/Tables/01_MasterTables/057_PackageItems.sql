CREATE TABLE [dbo].[PackageItems](
	[PackageItemID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NOT NULL,
	[ItemType] [varchar](50) NOT NULL,
	[ItemName] [nvarchar](200) NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TotalPrice]  AS ([Quantity]*[UnitPrice]),
	[BranchID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PackageItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
