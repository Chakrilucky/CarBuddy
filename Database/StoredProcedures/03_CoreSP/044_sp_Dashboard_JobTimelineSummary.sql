SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobTimelineSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        j.JobCardID,
        j.CreatedDate,
        j.CompletedOn,
        j.ActualDelivery,

        -- Time from Created → Completed
        CASE 
            WHEN j.CompletedOn IS NOT NULL 
            THEN DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
            ELSE NULL
        END AS HoursToComplete,

        -- Time from Completed → Delivered
        CASE 
            WHEN j.ActualDelivery IS NOT NULL AND j.CompletedOn IS NOT NULL
            THEN DATEDIFF(HOUR, j.CompletedOn, j.ActualDelivery)
            ELSE NULL
        END AS HoursToDeliver,

        -- Total repair cycle time
        CASE 
            WHEN j.ActualDelivery IS NOT NULL 
            THEN DATEDIFF(HOUR, j.CreatedDate, j.ActualDelivery)
            ELSE NULL
        END AS TotalHours
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        j.CreatedDate DESC;
END

GO
