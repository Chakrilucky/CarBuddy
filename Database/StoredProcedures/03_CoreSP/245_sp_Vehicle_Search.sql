SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vehicle_Search]
(
    @SearchText NVARCHAR(100),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 20
        V.VehicleID,
        V.RegistrationNumber,
        V.Model,
        C.FullName AS CustomerName
    FROM Vehicles V
    LEFT JOIN Customers C ON V.CustomerID = C.CustomerID
    WHERE V.BranchID = @BranchID
      AND (
            V.RegistrationNumber LIKE '%' + @SearchText + '%' OR
            V.Model LIKE '%' + @SearchText + '%' OR
            C.FullName LIKE '%' + @SearchText + '%'
          )
    ORDER BY V.RegistrationNumber;
END;

GO
