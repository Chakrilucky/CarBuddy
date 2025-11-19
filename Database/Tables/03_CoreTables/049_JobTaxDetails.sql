CREATE TABLE [dbo].[JobTaxDetails](
	[TaxDetailID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[InvoiceID] [int] NULL,
	[LabourTaxPercentage] [decimal](5, 2) NULL,
	[LabourTaxAmount] [decimal](14, 2) NULL,
	[PartsTaxPercentage] [decimal](5, 2) NULL,
	[PartsTaxAmount] [decimal](14, 2) NULL,
	[TowingTaxPercentage] [decimal](5, 2) NULL,
	[TowingTaxAmount] [decimal](14, 2) NULL,
	[CGST] [decimal](14, 2) NULL,
	[SGST] [decimal](14, 2) NULL,
	[IGST] [decimal](14, 2) NULL,
	[TotalTaxAmount] [decimal](14, 2) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TaxDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
