SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicles_Insert]
    @CustomerID INT,
    @RegistrationNumber VARCHAR(20),
    @ChassisNumber VARCHAR(50),
    @EngineNumber VARCHAR(50),
    @Manufacturer NVARCHAR(100),
    @Model NVARCHAR(100),
    @Variant NVARCHAR(100),
    @FuelType VARCHAR(20),
    @Transmission VARCHAR(20),
    @YearOfManufacture INT,
    @Color NVARCHAR(50),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Duplicate vehicle check
    IF EXISTS (SELECT 1 FROM Vehicles WHERE RegistrationNumber = @RegistrationNumber AND BranchID = @BranchID)
    BEGIN
        RAISERROR ('Vehicle already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Vehicles
    (
        CustomerID, RegistrationNumber, ChassisNumber, EngineNumber,
        Manufacturer, Model, Variant, FuelType, Transmission, 
        YearOfManufacture, Color, IsActive, CreatedDate, BranchID
    )
    VALUES
    (
        @CustomerID, @RegistrationNumber, @ChassisNumber, @EngineNumber,
        @Manufacturer, @Model, @Variant, @FuelType, @Transmission,
        @YearOfManufacture, @Color, 1, GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VehicleID;
END;

GO
