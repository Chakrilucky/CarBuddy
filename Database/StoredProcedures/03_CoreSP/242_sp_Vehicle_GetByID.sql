SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_GetByID]
(
    @VehicleID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Vehicles
    WHERE VehicleID = @VehicleID
      AND BranchID = @BranchID;
END;

GO
