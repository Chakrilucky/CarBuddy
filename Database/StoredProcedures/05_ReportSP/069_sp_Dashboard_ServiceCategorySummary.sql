SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ServiceCategorySummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.Category,
        COUNT(j.JobCardID) AS TotalJobs
    FROM JobCards j
    INNER JOIN ServiceTypes st
        ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND st.IsActive = 1
    GROUP BY 
        st.Category
    ORDER BY 
        TotalJobs DESC;
END

GO
