SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_Update]
(
    @VehicleID INT,
    @CustomerID INT,
    @RegistrationNumber VARCHAR(20),
    @ChassisNumber VARCHAR(50) = NULL,
    @EngineNumber VARCHAR(50) = NULL,
    @Manufacturer NVARCHAR(100),
    @Model NVARCHAR(100),
    @Variant NVARCHAR(100) = NULL,
    @FuelType VARCHAR(50),
    @Transmission VARCHAR(50) = NULL,
    @YearOfManufacture INT = NULL,
    @Color NVARCHAR(50) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate vehicle exists for this branch
    IF NOT EXISTS (
        SELECT 1 FROM Vehicles
        WHERE VehicleID = @VehicleID
          AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('Invalid VehicleID for this branch.', 16, 1);
        RETURN;
    END

    UPDATE Vehicles
    SET 
        CustomerID = @CustomerID,
        RegistrationNumber = @RegistrationNumber,
        ChassisNumber = @ChassisNumber,
        EngineNumber = @EngineNumber,
        Manufacturer = @Manufacturer,
        Model = @Model,
        Variant = @Variant,
        FuelType = @FuelType,
        Transmission = @Transmission,
        YearOfManufacture = @YearOfManufacture,
        Color = @Color,
        UpdatedDate = GETDATE()
    WHERE VehicleID = @VehicleID
      AND BranchID = @BranchID;
END;

GO
