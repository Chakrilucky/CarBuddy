SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_PartsConsumptionSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @TopCount INT = 10      -- default top 10 consumed parts
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        i.ItemID,
        i.ItemName,
        i.Category,
        SUM(jp.Quantity) AS TotalQuantityUsed,
        SUM(jp.TotalPrice) AS TotalAmount
    FROM JobParts jp
    INNER JOIN InventoryItems i 
        ON jp.ItemID = i.ItemID
    INNER JOIN JobCards j 
        ON jp.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND i.IsActive = 1
    GROUP BY 
        i.ItemID, i.ItemName, i.Category
    ORDER BY 
        TotalQuantityUsed DESC;
END

GO
