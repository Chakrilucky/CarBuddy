SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodayCompletedJobs]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        jc.JobCardID,
        jc.JobCardNumber,
        c.FullName AS CustomerName,
        v.RegistrationNumber,
        st.ServiceName AS ServiceTypeName,
        jc.CompletedOn AS CompletedDate
    FROM JobCards jc
        INNER JOIN Customers c ON jc.CustomerID = c.CustomerID
        INNER JOIN Vehicles v ON jc.VehicleID = v.VehicleID
        INNER JOIN ServiceTypes st ON jc.ServiceTypeID = st.ServiceTypeID
    WHERE 
        jc.BranchID = @BranchID
        AND jc.JobStatus = 'Completed'
        AND CONVERT(date, jc.CompletedOn) = CONVERT(date, GETDATE())
    ORDER BY jc.CompletedOn DESC;

END;

GO
