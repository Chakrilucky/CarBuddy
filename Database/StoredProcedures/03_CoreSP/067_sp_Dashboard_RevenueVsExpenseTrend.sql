SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_RevenueVsExpenseTrend]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    ------------------------------------------------------------------------
    -- 1. MONTHLY REVENUE (BASED ON COMPLETED JOBS)
    ------------------------------------------------------------------------
    ;WITH RevenueCTE AS
    (
        SELECT 
            FORMAT(j.CompletedOn, 'yyyy-MM') AS MonthName,
            COUNT(*) * 1 AS RevenueAmount     -- Placeholder (1₹ per job)
            -- Replace with InvoiceAmount when invoice table is ready
        FROM JobCards j
        WHERE 
            j.BranchID = @BranchID
            AND j.JobStatus = 'Delivered'
            AND j.CompletedOn BETWEEN @FromDate AND @ToDate
        GROUP BY 
            FORMAT(j.CompletedOn, 'yyyy-MM')
    ),


    ------------------------------------------------------------------------
    -- 2. MONTHLY EXPENSES
    ------------------------------------------------------------------------
    ExpenseCTE AS
    (
        SELECT 
            FORMAT(e.ExpenseDate, 'yyyy-MM') AS MonthName,
            SUM(e.Amount) AS ExpenseAmount
        FROM Expenses e
        WHERE 
            e.BranchID = @BranchID
            AND e.ExpenseDate BETWEEN @FromDate AND @ToDate
        GROUP BY 
            FORMAT(e.ExpenseDate, 'yyyy-MM')
    )


    ------------------------------------------------------------------------
    -- 3. FINAL MERGED TREND (REV - EXP)
    ------------------------------------------------------------------------
    SELECT 
        ISNULL(r.MonthName, e.MonthName) AS MonthName,
        ISNULL(r.RevenueAmount, 0) AS Revenue,
        ISNULL(e.ExpenseAmount, 0) AS Expense,
        ISNULL(r.RevenueAmount, 0) - ISNULL(e.ExpenseAmount, 0) AS Profit
    FROM RevenueCTE r
    FULL JOIN ExpenseCTE e 
        ON r.MonthName = e.MonthName
    ORDER BY 
        MonthName;

END

GO
