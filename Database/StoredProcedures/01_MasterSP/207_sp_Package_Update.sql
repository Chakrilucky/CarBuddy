SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_Update]
(
    @PackageID INT,
    @ServiceTypeID INT,
    @PackageName NVARCHAR(200),
    @PackagePrice DECIMAL(18,2),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Packages
    SET
        ServiceTypeID = @ServiceTypeID,
        PackageName = @PackageName,
        PackagePrice = @PackagePrice,
        Description = @Description,
        IsActive = @IsActive,
        UpdatedDate = GETDATE()
    WHERE PackageID = @PackageID
      AND BranchID = @BranchID;
END;

GO
