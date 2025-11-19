CREATE TABLE [dbo].[DocumentUploads](
	[DocumentID] [int] IDENTITY(1,1) NOT NULL,
	[RelatedTo] [varchar](50) NOT NULL,
	[CustomerID] [int] NULL,
	[VehicleID] [int] NULL,
	[JobCardID] [int] NULL,
	[JobStageID] [int] NULL,
	[InsuranceClaimID] [int] NULL,
	[PurchaseID] [int] NULL,
	[VendorID] [int] NULL,
	[FileName] [nvarchar](300) NOT NULL,
	[FilePath] [nvarchar](max) NOT NULL,
	[FileType] [nvarchar](50) NULL,
	[FileSizeKB] [int] NULL,
	[UploadedBy] [int] NULL,
	[UploadedDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
