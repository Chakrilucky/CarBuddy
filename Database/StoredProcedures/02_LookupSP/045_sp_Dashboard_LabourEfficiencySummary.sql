SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_LabourEfficiencySummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------
    -- TECHNICIAN WISE LABOUR EFFICIENCY SUMMARY
    ---------------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,

        -- Total Working Hours from Attendance
        ISNULL(SUM(a.TotalWorkingHours), 0) AS TotalWorkingHours,

        -- Total Job Hours (time spent on all jobs)
        ISNULL(SUM(
            CASE 
                WHEN j.CompletedOn IS NOT NULL 
                    THEN DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
                ELSE 
                    DATEDIFF(HOUR, j.CreatedDate, GETDATE())
            END
        ), 0) AS TotalJobHours,

        -- Jobs Completed
        ISNULL(SUM(
            CASE WHEN j.JobStatus = 'Completed' OR j.JobStatus = 'Delivered' THEN 1 ELSE 0 END
        ), 0) AS JobsCompleted,

        -- Efficiency %
        CASE 
            WHEN SUM(a.TotalWorkingHours) > 0 
                THEN CAST(
                    (SUM(
                        CASE 
                            WHEN j.CompletedOn IS NOT NULL 
                                THEN DATEDIFF(HOUR, j.CreatedDate, j.CompletedOn)
                            ELSE 
                                DATEDIFF(HOUR, j.CreatedDate, GETDATE())
                        END
                    ) * 100.0) / SUM(a.TotalWorkingHours)
                AS DECIMAL(5,2))
            ELSE 0
        END AS EfficiencyPercentage

    FROM Users u
    LEFT JOIN EmployeeAttendance a 
        ON u.UserID = a.UserID
        AND a.AttendanceDate BETWEEN @FromDate AND @ToDate

    LEFT JOIN JobCards j 
        ON u.UserID = j.AssignedTechnicianID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND j.BranchID = @BranchID

    WHERE 
        u.Role = 'Technician'
        AND u.BranchID = @BranchID
        AND u.IsActive = 1

    GROUP BY 
        u.UserID, u.FullName

    ORDER BY EfficiencyPercentage DESC;
END

GO
