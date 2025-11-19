CREATE TABLE [dbo].[InsuranceClaimDocuments](
	[ClaimDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceClaimID] [int] NOT NULL,
	[DocumentType] [varchar](100) NOT NULL,
	[FileName] [nvarchar](300) NOT NULL,
	[FilePath] [nvarchar](max) NOT NULL,
	[FileType] [nvarchar](50) NULL,
	[FileSizeKB] [int] NULL,
	[UploadedBy] [int] NULL,
	[UploadedDate] [datetime2](7) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
