SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_Complaints_List]
(
    @CustomerID INT = NULL,
    @VehicleID INT = NULL,
    @Status VARCHAR(50) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CT.ComplaintID,
        CT.CustomerID,
        C.FullName AS CustomerName,
        CT.VehicleID,
        V.RegistrationNumber AS VehicleNumber,
        CT.JobCardID,
        JC.JobCardNumber,

        CT.ComplaintTitle,
        CT.ComplaintDescription,
        CT.ComplaintCategory,
        CT.Priority,
        CT.ComplaintStatus,
        CT.AssignedToUserID,
        U.FullName AS AssignedTo,

        CT.ReportedDate,
        CT.ResolvedDate,
        CT.ResolutionRemarks,

        CT.CreatedDate,
        CT.UpdatedDate
    FROM ComplaintTickets CT
    LEFT JOIN Customers C ON CT.CustomerID = C.CustomerID
    LEFT JOIN Vehicles V ON CT.VehicleID = V.VehicleID
    LEFT JOIN JobCards JC ON CT.JobCardID = JC.JobCardID
    LEFT JOIN Users U ON CT.AssignedToUserID = U.UserID
    WHERE
        CT.BranchID = @BranchID
        AND (@CustomerID IS NULL OR CT.CustomerID = @CustomerID)
        AND (@VehicleID IS NULL OR CT.VehicleID = @VehicleID)
        AND (@Status IS NULL OR CT.ComplaintStatus = @Status)
    ORDER BY CT.ReportedDate DESC, CT.ComplaintID DESC;
END;

GO
