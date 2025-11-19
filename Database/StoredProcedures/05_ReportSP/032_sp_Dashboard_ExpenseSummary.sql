SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ExpenseSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------
    -- 1. TOTAL EXPENSE SUMMARY
    --------------------------------------------------------
    SELECT 
        SUM(Amount) AS TotalExpenses,
        COUNT(*) AS TotalExpenseEntries
    FROM Expenses
    WHERE 
        BranchID = @BranchID
        AND ExpenseDate BETWEEN @FromDate AND @ToDate;



    --------------------------------------------------------
    -- 2. CATEGORY-WISE EXPENSE SUMMARY
    --------------------------------------------------------
    SELECT 
        ec.CategoryName,
        SUM(e.Amount) AS TotalAmount,
        COUNT(e.ExpenseID) AS EntryCount
    FROM Expenses e
    INNER JOIN ExpenseCategory ec ON e.CategoryID = ec.CategoryID
    WHERE 
        e.BranchID = @BranchID
        AND e.ExpenseDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        ec.CategoryName
    ORDER BY 
        TotalAmount DESC;



    --------------------------------------------------------
    -- 3. DAILY EXPENSE BREAKDOWN
    --------------------------------------------------------
    SELECT 
        CAST(ExpenseDate AS DATE) AS ExpenseDay,
        SUM(Amount) AS DailyTotal
    FROM Expenses
    WHERE 
        BranchID = @BranchID
        AND ExpenseDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        CAST(ExpenseDate AS DATE)
    ORDER BY 
        ExpenseDay ASC;



    --------------------------------------------------------
    -- 4. RECENT EXPENSE LIST (with category name)
    --------------------------------------------------------
    SELECT 
        e.ExpenseID,
        ec.CategoryName,
        e.Amount,
        e.ExpenseDate,
        e.PaymentMode,
        e.VendorName,
        e.BillNumber
    FROM Expenses e
    INNER JOIN ExpenseCategory ec ON e.CategoryID = ec.CategoryID
    WHERE 
        e.BranchID = @BranchID
        AND e.ExpenseDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        e.ExpenseDate DESC;
END

GO
