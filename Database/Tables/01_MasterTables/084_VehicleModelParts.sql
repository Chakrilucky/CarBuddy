CREATE TABLE [dbo].[VehicleModelParts](
	[ModelPartID] [int] IDENTITY(1,1) NOT NULL,
	[ModelID] [int] NOT NULL,
	[PartID] [int] NOT NULL,
	[PartNumber] [nvarchar](100) NULL,
	[MRP] [decimal](14, 2) NOT NULL,
	[VendorPrice] [decimal](14, 2) NULL,
	[GSTPercentage] [decimal](5, 2) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ModelPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
