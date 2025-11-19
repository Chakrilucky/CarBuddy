SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_ListByCustomer]
(
    @CustomerID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        VehicleID,
        RegistrationNumber,
        Manufacturer,
        Model,
        Variant,
        FuelType,
        Transmission
    FROM Vehicles
    WHERE CustomerID = @CustomerID
      AND BranchID = @BranchID
    ORDER BY VehicleID DESC;
END;

GO
