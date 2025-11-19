SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerDocument_Add]
(
    @RelatedTo VARCHAR(50),        -- Customer / Vehicle / JobCard / Insurance / Purchase / Vendor
    @CustomerID INT = NULL,
    @VehicleID INT = NULL,
    @JobCardID INT = NULL,
    @JobStageID INT = NULL,
    @InsuranceClaimID INT = NULL,
    @PurchaseID INT = NULL,
    @VendorID INT = NULL,
    @FileName NVARCHAR(200),
    @FilePath NVARCHAR(500),
    @FileType NVARCHAR(50),
    @FileSizeKB INT,
    @UploadedBy INT,
    @Description NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DocumentUploads
    (
        RelatedTo,
        CustomerID,
        VehicleID,
        JobCardID,
        JobStageID,
        InsuranceClaimID,
        PurchaseID,
        VendorID,
        FileName,
        FilePath,
        FileType,
        FileSizeKB,
        UploadedBy,
        UploadedDate,
        Description,
        BranchID
    )
    VALUES
    (
        @RelatedTo,
        @CustomerID,
        @VehicleID,
        @JobCardID,
        @JobStageID,
        @InsuranceClaimID,
        @PurchaseID,
        @VendorID,
        @FileName,
        @FilePath,
        @FileType,
        @FileSizeKB,
        @UploadedBy,
        GETDATE(),
        @Description,
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS DocumentID;
END;

GO
