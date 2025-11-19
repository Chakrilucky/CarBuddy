SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCardImages_Add]
    @JobCardID INT,
    @ImageType VARCHAR(50),      -- Before / Progress / Final
    @ImagePath NVARCHAR(MAX),
    @UploadedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobCardImages
    (
        JobCardID, ImageType, ImagePath,
        UploadedBy, UploadedDate, BranchID
    )
    VALUES
    (
        @JobCardID, @ImageType, @ImagePath,
        @UploadedBy, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS ImageID;
END;

GO
