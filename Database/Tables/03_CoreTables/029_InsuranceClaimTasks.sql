CREATE TABLE [dbo].[InsuranceClaimTasks](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[AssignedToUserID] [int] NULL,
	[TaskTitle] [nvarchar](200) NOT NULL,
	[TaskDescription] [nvarchar](max) NULL,
	[TaskStatus] [varchar](50) NOT NULL,
	[DueDate] [datetime2](7) NULL,
	[CompletedDate] [datetime2](7) NULL,
	[Priority] [varchar](20) NOT NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
