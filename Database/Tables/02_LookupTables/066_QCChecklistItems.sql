CREATE TABLE [dbo].[QCChecklistItems](
	[QCItemID] [int] IDENTITY(1,1) NOT NULL,
	[ChecklistID] [int] NOT NULL,
	[ItemName] [nvarchar](300) NOT NULL,
	[ItemDescription] [nvarchar](max) NULL,
	[IsMandatory] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QCItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
