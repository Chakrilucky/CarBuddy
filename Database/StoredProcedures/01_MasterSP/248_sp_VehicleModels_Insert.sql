SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VehicleModels_Insert]
    @BrandName NVARCHAR(100),
    @ModelName NVARCHAR(150),
    @Variant NVARCHAR(100),
    @BodyTypeID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate check
    IF EXISTS (SELECT 1 FROM VehicleModels
               WHERE BrandName = @BrandName 
                 AND ModelName = @ModelName
                 AND ISNULL(Variant,'') = ISNULL(@Variant,'')
                 AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Vehicle model already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO VehicleModels
    (
        BrandName, ModelName, Variant, BodyTypeID,
        IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @BrandName, @ModelName, @Variant, @BodyTypeID,
        1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS ModelID;
END;

GO
