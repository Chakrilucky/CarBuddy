CREATE TABLE [dbo].[VehicleModels](
	[ModelID] [int] IDENTITY(1,1) NOT NULL,
	[BrandName] [nvarchar](100) NOT NULL,
	[ModelName] [nvarchar](150) NOT NULL,
	[Variant] [nvarchar](100) NULL,
	[BodyTypeID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ModelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
