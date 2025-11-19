SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PartsRevenueBreakdown]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------
    -- 1. TOTAL PARTS VS LABOUR REVENUE
    -----------------------------------------------------
    SELECT 
        SUM(PartsAmount) AS TotalPartsRevenue,
        SUM(LabourAmount) AS TotalLabourRevenue,
        SUM(PartsAmount + LabourAmount) AS TotalCombinedRevenue
    FROM Invoices
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    -----------------------------------------------------
    -- 2. PARTS REVENUE PERCENTAGE
    -----------------------------------------------------
    SELECT 
        CASE 
            WHEN SUM(PartsAmount + LabourAmount) = 0 THEN 0
            ELSE 
                (SUM(PartsAmount) * 100.0) /
                SUM(PartsAmount + LabourAmount)
        END AS PartsPercentage,

        CASE 
            WHEN SUM(PartsAmount + LabourAmount) = 0 THEN 0
            ELSE 
                (SUM(LabourAmount) * 100.0) /
                SUM(PartsAmount + LabourAmount)
        END AS LabourPercentage
    FROM Invoices
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    -----------------------------------------------------
    -- 3. TOP JOBS BY PARTS USAGE (HIGH PARTS VALUE)
    -----------------------------------------------------
    SELECT TOP 10
        i.InvoiceID,
        j.JobCardID,
        i.PartsAmount,
        i.LabourAmount,
        i.NetAmount,
        j.CreatedDate
    FROM Invoices i
    INNER JOIN JobCards j ON i.JobCardID = j.JobCardID
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        i.PartsAmount DESC;



    -----------------------------------------------------
    -- 4. PARTS REVENUE DAILY BREAKDOWN
    -----------------------------------------------------
    SELECT 
        CAST(i.CreatedDate AS DATE) AS InvoiceDate,
        SUM(i.PartsAmount) AS PartsRevenue,
        SUM(i.LabourAmount) AS LabourRevenue,
        SUM(i.NetAmount) AS TotalRevenue
    FROM Invoices i
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        CAST(i.CreatedDate AS DATE)
    ORDER BY 
        InvoiceDate ASC;

END

GO
