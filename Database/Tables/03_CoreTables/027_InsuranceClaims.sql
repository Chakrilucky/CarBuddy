CREATE TABLE [dbo].[InsuranceClaims](
	[InsuranceClaimID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[InsuranceCompanyID] [int] NOT NULL,
	[ClaimNumber] [nvarchar](100) NOT NULL,
	[ClaimType] [varchar](50) NOT NULL,
	[ClaimStatus] [varchar](50) NOT NULL,
	[SurveyorName] [nvarchar](150) NULL,
	[SurveyorMobile] [varchar](15) NULL,
	[SurveyorVisitDate] [datetime2](7) NULL,
	[ApprovedAmount] [decimal](12, 2) NULL,
	[RejectedReason] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[PolicyNumber] [nvarchar](100) NULL,
	[EstimateAmount] [decimal](18, 2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InsuranceClaimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ClaimNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
