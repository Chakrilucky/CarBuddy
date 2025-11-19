SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_LabourVsPartsTrend]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------------------
    -- MONTH WISE LABOUR vs PARTS REVENUE TREND
    -------------------------------------------------------------------
    SELECT
        FORMAT(i.CreatedDate, 'yyyy-MM') AS MonthName,
        SUM(i.LabourAmount) AS TotalLabourRevenue,
        SUM(i.PartsAmount) AS TotalPartsRevenue,
        SUM(i.NetAmount) AS TotalRevenue
    FROM Invoices i
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        FORMAT(i.CreatedDate, 'yyyy-MM')
    ORDER BY 
        MonthName ASC;

END

GO
