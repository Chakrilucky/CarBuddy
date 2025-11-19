SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ProfitSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------
    -- 1. TOTAL REVENUE
    --------------------------------------------------
    SELECT 
        SUM(NetAmount) AS TotalRevenue
    FROM Invoices
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    --------------------------------------------------
    -- 2. TOTAL EXPENSES
    --------------------------------------------------
    SELECT 
        SUM(Amount) AS TotalExpenses
    FROM Expenses
    WHERE 
        BranchID = @BranchID
        AND ExpenseDate BETWEEN @FromDate AND @ToDate;



    --------------------------------------------------
    -- 3. NET PROFIT
    --------------------------------------------------
    SELECT
        (SELECT SUM(NetAmount) 
         FROM Invoices
         WHERE BranchID = @BranchID
           AND CreatedDate BETWEEN @FromDate AND @ToDate
        ) 
        -
        (SELECT SUM(Amount) 
         FROM Expenses
         WHERE BranchID = @BranchID
           AND ExpenseDate BETWEEN @FromDate AND @ToDate
        ) AS NetProfit;



    --------------------------------------------------
    -- 4. DAILY REVENUE - EXPENSE - PROFIT BREAKDOWN
    --------------------------------------------------

    ;WITH DateRange AS 
    (
        SELECT @FromDate AS TheDate
        UNION ALL
        SELECT DATEADD(DAY, 1, TheDate)
        FROM DateRange
        WHERE DATEADD(DAY, 1, TheDate) <= @ToDate
    ),

    RevenueData AS
    (
        SELECT 
            CAST(CreatedDate AS DATE) AS RDate,
            SUM(NetAmount) AS Revenue
        FROM Invoices
        WHERE 
            BranchID = @BranchID
            AND CreatedDate BETWEEN @FromDate AND @ToDate
        GROUP BY CAST(CreatedDate AS DATE)
    ),

    ExpenseData AS
    (
        SELECT 
            CAST(ExpenseDate AS DATE) AS EDate,
            SUM(Amount) AS Expense
        FROM Expenses
        WHERE 
            BranchID = @BranchID
            AND ExpenseDate BETWEEN @FromDate AND @ToDate
        GROUP BY CAST(ExpenseDate AS DATE)
    )

    SELECT 
        d.TheDate,
        ISNULL(r.Revenue, 0) AS Revenue,
        ISNULL(e.Expense, 0) AS Expense,
        ISNULL(r.Revenue, 0) - ISNULL(e.Expense, 0) AS Profit
    FROM DateRange d
    LEFT JOIN RevenueData r ON d.TheDate = r.RDate
    LEFT JOIN ExpenseData e ON d.TheDate = e.EDate
    ORDER BY d.TheDate ASC
    OPTION (MAXRECURSION 0);

END

GO
