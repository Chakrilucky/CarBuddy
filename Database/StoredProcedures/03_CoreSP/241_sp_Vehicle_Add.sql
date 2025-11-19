SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_Add]
(
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

    -- Prevent duplicate vehicle for same branch
    IF EXISTS (
        SELECT 1 FROM Vehicles
        WHERE RegistrationNumber = @RegistrationNumber
          AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('A vehicle with this registration number already exists in this branch.', 16, 1);
        RETURN;
    END

    INSERT INTO Vehicles
    (
        CustomerID,
        RegistrationNumber,
        ChassisNumber,
        EngineNumber,
        Manufacturer,
        Model,
        Variant,
        FuelType,
        Transmission,
        YearOfManufacture,
        Color,
        IsActive,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @CustomerID,
        @RegistrationNumber,
        @ChassisNumber,
        @EngineNumber,
        @Manufacturer,
        @Model,
        @Variant,
        @FuelType,
        @Transmission,
        @YearOfManufacture,
        @Color,
        1,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VehicleID;
END;

GO
