SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobCardsByStatus]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        jc.JobStatus,
        COUNT(*) AS TotalCount
    FROM JobCards jc
    WHERE jc.BranchID = @BranchID
    GROUP BY jc.JobStatus
    ORDER BY jc.JobStatus;

END;

GO
