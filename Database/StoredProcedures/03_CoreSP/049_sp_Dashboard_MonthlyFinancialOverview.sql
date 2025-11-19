SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_MonthlyFinancialOverview]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------
    -- Generate last 12 months
    --------------------------------------------------------
    ;WITH Months AS
    (
        SELECT 
            DATEFROMPARTS(YEAR(DATEADD(MONTH, -11, GETDATE())), 
                           MONTH(DATEADD(MONTH, -11, GETDATE())), 1) AS MonthStart
        UNION ALL
        SELECT DATEADD(MONTH, 1, MonthStart)
        FROM Months
        WHERE MonthStart < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
    ),

    RevenueData AS
    (
        SELECT 
            YEAR(CreatedDate) AS Y,
            MONTH(CreatedDate) AS M,
            SUM(NetAmount) AS Revenue
        FROM Invoices
        WHERE BranchID = @BranchID
        GROUP BY YEAR(CreatedDate), MONTH(CreatedDate)
    ),

    ExpenseData AS
    (
        SELECT 
            YEAR(ExpenseDate) AS Y,
            MONTH(ExpenseDate) AS M,
            SUM(Amount) AS Expense
        FROM Expenses
        WHERE BranchID = @BranchID
        GROUP BY YEAR(ExpenseDate), MONTH(ExpenseDate)
    )

    SELECT 
        FORMAT(m.MonthStart, 'MMM yyyy') AS MonthName,
        ISNULL(r.Revenue, 0) AS Revenue,
        ISNULL(e.Expense, 0) AS Expense,
        ISNULL(r.Revenue, 0) - ISNULL(e.Expense, 0) AS Profit
    FROM Months m
    LEFT JOIN RevenueData r 
        ON YEAR(m.MonthStart) = r.Y AND MONTH(m.MonthStart) = r.M
    LEFT JOIN ExpenseData e 
        ON YEAR(m.MonthStart) = e.Y AND MONTH(m.MonthStart) = e.M
    ORDER BY m.MonthStart
    OPTION (MAXRECURSION 0);

END

GO
