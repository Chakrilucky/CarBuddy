SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimDocument_List]
(
    @InsuranceClaimID INT,
    @BranchID INT
)
AS
BEGIN
    SELECT 
        ClaimDocumentID,
        InsuranceClaimID,
        DocumentType,
        FileName,
        FilePath,
        FileType,
        FileSizeKB,
        UploadedBy,
        UploadedDate,
        Notes
    FROM InsuranceClaimDocuments
    WHERE InsuranceClaimID = @InsuranceClaimID
      AND BranchID = @BranchID
    ORDER BY UploadedDate DESC;
END;

GO
