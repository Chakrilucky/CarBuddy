CREATE TABLE [dbo].[InsuranceSurveyorVisits](
	[SurveyVisitID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[VisitDate] [datetime2](7) NOT NULL,
	[VisitType] [varchar](50) NOT NULL,
	[SurveyorName] [nvarchar](150) NULL,
	[SurveyorMobile] [varchar](15) NULL,
	[VisitStatus] [varchar](50) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[PhotoPath1] [nvarchar](max) NULL,
	[PhotoPath2] [nvarchar](max) NULL,
	[PhotoPath3] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SurveyVisitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
