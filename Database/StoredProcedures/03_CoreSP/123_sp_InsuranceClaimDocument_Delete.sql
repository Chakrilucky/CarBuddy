SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimDocument_Delete]
(
    @ClaimDocumentID INT,
    @BranchID INT
)
AS
BEGIN
    DELETE FROM InsuranceClaimDocuments
    WHERE ClaimDocumentID = @ClaimDocumentID
      AND BranchID = @BranchID;
END;

GO
