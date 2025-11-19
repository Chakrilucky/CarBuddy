SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopIssuesReported]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        j.Remarks AS IssueReported,
        COUNT(j.JobCardID) AS ReportCount,
        MIN(j.CreatedDate) AS FirstReported,
        MAX(j.CreatedDate) AS LastReported
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.Remarks IS NOT NULL
        AND LTRIM(RTRIM(j.Remarks)) <> ''
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        j.Remarks
    ORDER BY 
        ReportCount DESC;
END

GO
