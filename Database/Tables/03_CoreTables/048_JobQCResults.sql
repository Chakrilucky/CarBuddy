CREATE TABLE [dbo].[JobQCResults](
	[QCResultID] [int] IDENTITY(1,1) NOT NULL,
	[JobCardID] [int] NOT NULL,
	[QCItemID] [int] NOT NULL,
	[QCStatus] [varchar](20) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[PhotoPath] [nvarchar](max) NULL,
	[CheckedByUserID] [int] NULL,
	[CheckedDate] [datetime2](7) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QCResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
