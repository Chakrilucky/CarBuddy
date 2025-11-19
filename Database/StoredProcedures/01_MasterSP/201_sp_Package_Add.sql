SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_Add]
(
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

    INSERT INTO Packages
    (
        ServiceTypeID,
        PackageName,
        PackagePrice,
        Description,
        IsActive,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @ServiceTypeID,
        @PackageName,
        @PackagePrice,
        @Description,
        @IsActive,
        GETDATE(),
        @BranchID
    );
END;

GO
