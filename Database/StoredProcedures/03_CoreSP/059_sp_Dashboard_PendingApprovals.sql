SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PendingApprovals]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        E.EstimateID,
        E.JobCardID,
        JC.JobCardNumber,
        C.FullName AS CustomerName,     -- FIXED HERE
        V.RegistrationNumber,
        E.EstimatedAmount,
        E.EstimateDate,
        E.ApprovalStatus
    FROM JobEstimates E
    INNER JOIN JobCards JC 
        ON E.JobCardID = JC.JobCardID 
        AND JC.BranchID = @BranchID
    INNER JOIN Customers C 
        ON JC.CustomerID = C.CustomerID
    INNER JOIN Vehicles V 
        ON JC.VehicleID = V.VehicleID
    WHERE 
        E.ApprovalStatus = 'Pending'
        AND E.BranchID = @BranchID
    ORDER BY 
        E.EstimateDate DESC;
END;

GO
