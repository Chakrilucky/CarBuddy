CREATE TABLE [dbo].[EmployeeSalary](
	[SalaryID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[SalaryMonth] [int] NOT NULL,
	[SalaryYear] [int] NOT NULL,
	[SalaryType] [varchar](20) NOT NULL,
	[BasicSalary] [decimal](10, 2) NULL,
	[DailyWage] [decimal](10, 2) NULL,
	[PresentDays] [int] NOT NULL,
	[AbsentDays] [int] NOT NULL,
	[LeaveDays] [int] NOT NULL,
	[OvertimeHours] [decimal](10, 2) NOT NULL,
	[OvertimeAmount] [decimal](10, 2) NOT NULL,
	[Allowances] [decimal](10, 2) NOT NULL,
	[Deductions] [decimal](10, 2) NOT NULL,
	[CalculatedSalary]  AS (case when [SalaryType]='Monthly' then (([BasicSalary]+[Allowances])+[OvertimeAmount])-[Deductions] when [SalaryType]='Daily' then (([PresentDays]*[DailyWage]+[Allowances])+[OvertimeAmount])-[Deductions] else (0) end) PERSISTED,
	[PaymentStatus] [varchar](20) NOT NULL,
	[PaymentDate] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SalaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
