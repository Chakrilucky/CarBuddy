CREATE TABLE [dbo].[InsuranceClaimApprovals](
	[ClaimApprovalID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[ApprovalType] [varchar](50) NOT NULL,
	[ApprovedAmount] [decimal](12, 2) NULL,
	[RejectedReason] [nvarchar](max) NULL,
	[ApprovedBy] [nvarchar](150) NULL,
	[ApprovalDate] [datetime2](7) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimApprovalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
