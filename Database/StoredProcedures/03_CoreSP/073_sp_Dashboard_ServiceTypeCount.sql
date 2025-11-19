SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_ServiceTypeCount]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.ServiceName,
        COUNT(j.JobCardID) AS JobCount
    FROM JobCards j
    INNER JOIN ServiceTypes st 
        ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
        AND st.IsActive = 1     -- service type is active
    GROUP BY st.ServiceName
    ORDER BY JobCount DESC;
END

GO
