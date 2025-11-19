CREATE TABLE [dbo].[Technicians](
	[TechnicianID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[TechnicianName] [nvarchar](150) NOT NULL,
	[MobileNumber] [varchar](15) NOT NULL,
	[SkillLevel] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[UpdatedDate] [datetime2](7) NULL,
	[BranchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TechnicianID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
