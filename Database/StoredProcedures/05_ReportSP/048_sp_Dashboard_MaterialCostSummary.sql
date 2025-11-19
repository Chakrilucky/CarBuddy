SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_MaterialCostSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. TOTAL MATERIAL COST
    SELECT 
        SUM(jp.TotalPrice) AS TotalMaterialCost,
        SUM(jp.Quantity) AS TotalQuantityUsed
    FROM JobParts jp
    INNER JOIN JobCards j ON jp.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate;



    -- 2. COST BY ITEM CATEGORY
    SELECT 
        i.Category,
        SUM(jp.TotalPrice) AS TotalCost,
        SUM(jp.Quantity) AS QuantityUsed
    FROM JobParts jp
    INNER JOIN InventoryItems i ON jp.ItemID = i.ItemID
    INNER JOIN JobCards j ON jp.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND i.IsActive = 1
    GROUP BY 
        i.Category
    ORDER BY 
        TotalCost DESC;



    -- 3. COST BY SERVICE TYPE (MECH/PAINT/ELECTRICAL ETC.)
    SELECT 
        st.ServiceName,
        SUM(jp.TotalPrice) AS TotalCost
    FROM JobParts jp
    INNER JOIN JobCards j ON jp.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        TotalCost DESC;
END

GO
