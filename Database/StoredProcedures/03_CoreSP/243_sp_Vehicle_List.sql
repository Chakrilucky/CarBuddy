SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        V.VehicleID,
        V.CustomerID,
        C.FullName AS CustomerName,
        V.RegistrationNumber,
        V.Manufacturer,
        V.Model,
        V.Variant,
        V.FuelType,
        V.Transmission,
        V.Color,
        V.YearOfManufacture,
        V.CreatedDate,
        V.IsActive
    FROM Vehicles V
    LEFT JOIN Customers C ON V.CustomerID = C.CustomerID
    WHERE V.BranchID = @BranchID
    ORDER BY V.CreatedDate DESC, V.VehicleID DESC;
END;

GO
