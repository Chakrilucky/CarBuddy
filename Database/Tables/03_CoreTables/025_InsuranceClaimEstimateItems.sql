CREATE TABLE [dbo].[InsuranceClaimEstimateItems](
	[ClaimEstimateItemID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[ItemType] [varchar](50) NOT NULL,
	[ItemName] [nvarchar](200) NOT NULL,
	[ItemDescription] [nvarchar](max) NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[RequestedUnitPrice] [decimal](10, 2) NOT NULL,
	[RequestedTotalPrice]  AS ([Quantity]*[RequestedUnitPrice]) PERSISTED,
	[IsApproved] [bit] NULL,
	[ApprovedUnitPrice] [decimal](10, 2) NULL,
	[ApprovedTotalPrice]  AS (case when [ApprovedUnitPrice] IS NOT NULL then [Quantity]*[ApprovedUnitPrice]  end) PERSISTED,
	[SurveyorRemarks] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimEstimateItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
