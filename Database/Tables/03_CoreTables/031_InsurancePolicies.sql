CREATE TABLE [dbo].[InsurancePolicies](
	[PolicyID] [int] IDENTITY(1,1) NOT NULL,
	[VehicleID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[InsuranceCompanyID] [int] NOT NULL,
	[PolicyNumber] [nvarchar](100) NOT NULL,
	[PolicyType] [varchar](50) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[IDV] [decimal](12, 2) NULL,
	[PremiumAmount] [decimal](12, 2) NULL,
	[AgentName] [nvarchar](150) NULL,
	[AgentContact] [varchar](15) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PolicyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
