CREATE TABLE [dbo].[BayAssignments](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[BayID] [int] NOT NULL,
	[JobCardID] [int] NOT NULL,
	[AssignedTechnicianID] [int] NULL,
	[AssignmentStatus] [varchar](50) NOT NULL,
	[AssignedDate] [datetime2](7) NOT NULL,
	[CompletedDate] [datetime2](7) NULL,
	[Notes] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AssignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
