CREATE TABLE [dbo].[Vendors](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](200) NOT NULL,
	[ContactPerson] [nvarchar](150) NULL,
	[MobileNumber] [varchar](15) NULL,
	[AlternateMobile] [varchar](15) NULL,
	[Email] [nvarchar](150) NULL,
	[AddressLine1] [nvarchar](200) NULL,
	[AddressLine2] [nvarchar](200) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[Pincode] [varchar](10) NULL,
	[GSTNumber] [nvarchar](20) NULL,
	[PANNumber] [nvarchar](20) NULL,
	[PaymentTerms] [nvarchar](150) NULL,
	[Notes] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
