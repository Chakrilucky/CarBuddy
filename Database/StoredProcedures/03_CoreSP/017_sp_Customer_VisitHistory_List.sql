SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_VisitHistory_List]
(
    @CustomerID INT = NULL,
    @VehicleID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        VVH.VisitID,
        VVH.VisitDate,
        VVH.VisitType,
        VVH.VehicleID,
        VC.RegistrationNumber AS VehicleNumber,
        VVH.CustomerID,
        C.FullName AS CustomerName,
        VVH.JobCardID,
        JC.JobCardNumber,
        VVH.OdometerReading,
        VVH.Complaints,
        VVH.Observations,
        VVH.AttendedByUserID,
        U.FullName AS AttendedBy,
        VVH.Notes,
        VVH.CreatedDate
    FROM VehicleVisitHistory VVH
    LEFT JOIN Vehicles VC ON VVH.VehicleID = VC.VehicleID
    LEFT JOIN Customers C ON VVH.CustomerID = C.CustomerID
    LEFT JOIN JobCards JC ON VVH.JobCardID = JC.JobCardID
    LEFT JOIN Users U ON VVH.AttendedByUserID = U.UserID
    WHERE 
        VVH.BranchID = @BranchID
        AND (@CustomerID IS NULL OR VVH.CustomerID = @CustomerID)
        AND (@VehicleID IS NULL OR VVH.VehicleID = @VehicleID)
    ORDER BY VVH.VisitDate DESC, VVH.VisitID DESC;
END;

GO
