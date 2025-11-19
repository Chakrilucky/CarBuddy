SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerDocument_List]
(
    @CustomerID INT = NULL,
    @VehicleID INT = NULL,
    @JobCardID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DU.DocumentID,
        DU.RelatedTo,
        DU.CustomerID,
        DU.VehicleID,
        DU.JobCardID,
        DU.JobStageID,
        DU.InsuranceClaimID,
        DU.PurchaseID,
        DU.VendorID,
        DU.FileName,
        DU.FilePath,
        DU.FileType,
        DU.FileSizeKB,
        DU.UploadedBy,
        U.FullName AS UploadedByName,
        DU.UploadedDate,
        DU.Description,
        DU.BranchID
    FROM DocumentUploads DU
    LEFT JOIN Users U ON DU.UploadedBy = U.UserID
    WHERE 
        DU.BranchID = @BranchID
        AND (@CustomerID IS NULL OR DU.CustomerID = @CustomerID)
        AND (@VehicleID IS NULL OR DU.VehicleID = @VehicleID)
        AND (@JobCardID IS NULL OR DU.JobCardID = @JobCardID)
    ORDER BY DU.UploadedDate DESC, DU.DocumentID DESC;
END;

GO
