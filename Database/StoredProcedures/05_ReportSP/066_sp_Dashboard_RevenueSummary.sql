SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_RevenueSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- TOTAL REVENUE
    SELECT 
        SUM(i.NetAmount) AS TotalRevenue,
        SUM(CASE WHEN j.PriorityTypeID = 2 THEN i.NetAmount ELSE 0 END) AS PremiumRevenue,
        SUM(CASE WHEN j.InsuranceClaimID IS NOT NULL THEN i.NetAmount ELSE 0 END) AS InsuranceRevenue
    FROM Invoices i
    INNER JOIN JobCards j ON i.JobCardID = j.JobCardID
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate;

    -- REVENUE BY SERVICE TYPE (GENERAL/MECHANICAL/PAINTING/AC etc.)
    SELECT 
        st.ServiceName,
        SUM(i.NetAmount) AS Revenue
    FROM Invoices i
    INNER JOIN JobCards j ON i.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        i.BranchID = @BranchID
        AND i.CreatedDate BETWEEN @FromDate AND @ToDate
        AND st.IsActive = 1
    GROUP BY 
        st.ServiceName
    ORDER BY 
        Revenue DESC;
END

GO
