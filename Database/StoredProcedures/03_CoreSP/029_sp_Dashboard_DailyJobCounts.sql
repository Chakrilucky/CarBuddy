SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_DailyJobCounts]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Dates AS (
        SELECT CAST(GETDATE() AS DATE) AS TheDate
        UNION ALL
        SELECT DATEADD(DAY, -1, TheDate)
        FROM Dates
        WHERE DATEADD(DAY, -1, TheDate) >= DATEADD(DAY, -13, CAST(GETDATE() AS DATE))
    )
    SELECT 
        d.TheDate,
        ISNULL(COUNT(jc.JobCardID), 0) AS JobCount
    FROM Dates d
        LEFT JOIN JobCards jc 
            ON CONVERT(date, jc.CreatedDate) = d.TheDate
            AND jc.BranchID = @BranchID
    GROUP BY d.TheDate
    ORDER BY d.TheDate ASC;
END;

GO
