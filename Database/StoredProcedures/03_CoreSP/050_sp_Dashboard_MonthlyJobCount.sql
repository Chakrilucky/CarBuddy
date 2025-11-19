SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_MonthlyJobCount]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  
        FORMAT(CreatedDate, 'yyyy-MM') AS JobMonth,
        COUNT(*) AS TotalJobs
    FROM JobCards
    WHERE BranchID = @BranchID
    GROUP BY FORMAT(CreatedDate, 'yyyy-MM')
    ORDER BY JobMonth;
END;

GO
