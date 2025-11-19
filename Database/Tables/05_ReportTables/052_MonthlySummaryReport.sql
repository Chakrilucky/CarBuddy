CREATE TABLE [dbo].[MonthlySummaryReport](
	[MonthlyReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportMonth] [varchar](7) NOT NULL,
	[TotalRevenue] [decimal](14, 2) NOT NULL,
	[TotalRefunds] [decimal](14, 2) NOT NULL,
	[CashTotal] [decimal](14, 2) NOT NULL,
	[UPITotal] [decimal](14, 2) NOT NULL,
	[CardTotal] [decimal](14, 2) NOT NULL,
	[BankTransferTotal] [decimal](14, 2) NOT NULL,
	[TotalJobs] [int] NOT NULL,
	[CompletedJobs] [int] NOT NULL,
	[CancelledJobs] [int] NOT NULL,
	[PaintingRevenue] [decimal](14, 2) NOT NULL,
	[MechanicalRevenue] [decimal](14, 2) NOT NULL,
	[WashingRevenue] [decimal](14, 2) NOT NULL,
	[PartsRevenue] [decimal](14, 2) NOT NULL,
	[LabourRevenue] [decimal](14, 2) NOT NULL,
	[InsuranceClaimRevenue] [decimal](14, 2) NOT NULL,
	[EstimatedProfit] [decimal](14, 2) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MonthlyReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ReportMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
