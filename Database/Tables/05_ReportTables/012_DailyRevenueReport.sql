CREATE TABLE [dbo].[DailyRevenueReport](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportDate] [date] NOT NULL,
	[TotalPayments] [decimal](14, 2) NOT NULL,
	[TotalRefunds] [decimal](14, 2) NOT NULL,
	[CashTotal] [decimal](14, 2) NOT NULL,
	[UPITotal] [decimal](14, 2) NOT NULL,
	[CardTotal] [decimal](14, 2) NOT NULL,
	[BankTransferTotal] [decimal](14, 2) NOT NULL,
	[TotalJobs] [int] NOT NULL,
	[CompletedJobs] [int] NOT NULL,
	[PendingJobs] [int] NOT NULL,
	[PaintingRevenue] [decimal](14, 2) NOT NULL,
	[MechanicalRevenue] [decimal](14, 2) NOT NULL,
	[WashingRevenue] [decimal](14, 2) NOT NULL,
	[PartSalesRevenue] [decimal](14, 2) NOT NULL,
	[LabourRevenue] [decimal](14, 2) NOT NULL,
	[InsuranceClaimRevenue] [decimal](14, 2) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ReportDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
