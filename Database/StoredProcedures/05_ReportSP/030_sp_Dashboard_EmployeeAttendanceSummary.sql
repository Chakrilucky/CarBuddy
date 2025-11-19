SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_EmployeeAttendanceSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------
    -- 1. TOTAL EMPLOYEES IN THIS BRANCH
    --------------------------------------------
    SELECT 
        COUNT(*) AS TotalEmployees
    FROM Users
    WHERE 
        BranchID = @BranchID
        AND IsActive = 1
        AND Role IN ('Technician', 'Supervisor', 'FrontDesk', 'Helper');


    --------------------------------------------
    -- 2. TODAY ATTENDANCE SUMMARY
    --------------------------------------------
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    SELECT 
        SUM(CASE WHEN AttendanceStatus = 'Present' THEN 1 ELSE 0 END) AS PresentToday,
        SUM(CASE WHEN AttendanceStatus = 'Absent' THEN 1 ELSE 0 END) AS AbsentToday,
        SUM(CASE WHEN AttendanceStatus = 'HalfDay' THEN 1 ELSE 0 END) AS HalfDayToday,
        SUM(CASE WHEN AttendanceStatus = 'Present' 
                 AND CheckInTime IS NOT NULL
                 AND CONVERT(time, CheckInTime) > '09:30' THEN 1 ELSE 0 END) AS LateEmployees
    FROM EmployeeAttendance
    WHERE 
        BranchID = @BranchID
        AND AttendanceDate = @Today;


    --------------------------------------------
    -- 3. DATE RANGE ATTENDANCE ANALYSIS
    --------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        COUNT(a.AttendanceID) AS TotalDaysRecorded,
        SUM(CASE WHEN a.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) AS DaysPresent,
        SUM(CASE WHEN a.AttendanceStatus = 'Absent' THEN 1 ELSE 0 END) AS DaysAbsent,
        SUM(CASE WHEN a.AttendanceStatus = 'HalfDay' THEN 1 ELSE 0 END) AS HalfDays,
        CAST(
            (SUM(CASE WHEN a.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) * 100.0)
            / NULLIF(COUNT(a.AttendanceID), 0)
        AS DECIMAL(5,2)) AS AttendancePercentage
    FROM Users u
    LEFT JOIN EmployeeAttendance a 
        ON u.UserID = a.UserID
        AND a.AttendanceDate BETWEEN @FromDate AND @ToDate
    WHERE 
        u.BranchID = @BranchID
        AND u.IsActive = 1
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        AttendancePercentage DESC;


    --------------------------------------------
    -- 4. TODAY'S EMPLOYEE LIST WITH STATUS
    --------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        a.AttendanceStatus,
        a.CheckInTime,
        a.CheckOutTime
    FROM Users u
    LEFT JOIN EmployeeAttendance a 
        ON u.UserID = a.UserID
       AND a.AttendanceDate = @Today
    WHERE 
        u.BranchID = @BranchID
        AND u.IsActive = 1
    ORDER BY 
        u.FullName;
END

GO
