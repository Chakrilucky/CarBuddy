SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_SparePartsConsumptionSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    ----------------------------------------------------------------------
    -- 1. TOP PARTS USED (QUANTITY)
    ----------------------------------------------------------------------
    SELECT 
        p.PartID,
        p.PartName,
        SUM(jcp.Quantity) AS TotalQuantityUsed
    FROM JobCardParts jcp
    INNER JOIN SpareParts p ON p.PartID = jcp.PartID
    INNER JOIN JobCards j ON j.JobCardID = jcp.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        p.PartID, p.PartName
    ORDER BY 
        TotalQuantityUsed DESC;



    ----------------------------------------------------------------------
    -- 2. PART-WISE VALUE CONSUMPTION
    ----------------------------------------------------------------------
    SELECT 
        p.PartName,
        SUM(jcp.TotalPrice) AS TotalValueUsed
    FROM JobCardParts jcp
    INNER JOIN SpareParts p ON p.PartID = jcp.PartID
    INNER JOIN JobCards j ON j.JobCardID = jcp.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        p.PartName
    ORDER BY 
        TotalValueUsed DESC;



    ----------------------------------------------------------------------
    -- 3. DAILY / MONTHLY PART CONSUMPTION TREND
    ----------------------------------------------------------------------
    SELECT 
        FORMAT(j.CreatedDate, 'yyyy-MM') AS MonthName,
        SUM(jcp.Quantity) AS TotalPartsUsed
    FROM JobCardParts jcp
    INNER JOIN JobCards j ON j.JobCardID = jcp.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        FORMAT(j.CreatedDate, 'yyyy-MM')
    ORDER BY 
        MonthName;



    ----------------------------------------------------------------------
    -- 4. DETAILED PART USAGE (FOR PARTS REPORT PAGE)
    ----------------------------------------------------------------------
    SELECT 
        j.JobCardID,
        j.JobCardNumber,
        p.PartName,
        jcp.Quantity,
        jcp.TotalPrice,
        j.CreatedDate
    FROM JobCardParts jcp
    INNER JOIN SpareParts p ON p.PartID = jcp.PartID
    INNER JOIN JobCards j ON j.JobCardID = jcp.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        j.CreatedDate DESC;

END

GO
