SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimDocument_Add]
(
    @InsuranceClaimID INT,
    @DocumentType VARCHAR(50),
    @FileName NVARCHAR(200),
    @FilePath NVARCHAR(300),
    @FileType NVARCHAR(50),
    @FileSizeKB INT,
    @UploadedBy INT,
    @Notes NVARCHAR(500) = NULL,
    @BranchID INT
)
AS
BEGIN
    INSERT INTO InsuranceClaimDocuments
    (
        InsuranceClaimID,
        DocumentType,
        FileName,
        FilePath,
        FileType,
        FileSizeKB,
        UploadedBy,
        UploadedDate,
        Notes,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        @DocumentType,
        @FileName,
        @FilePath,
        @FileType,
        @FileSizeKB,
        @UploadedBy,
        GETDATE(),
        @Notes,
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewDocumentID;
END;

GO
