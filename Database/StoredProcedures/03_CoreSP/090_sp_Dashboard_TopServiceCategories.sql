SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TopServiceCategories]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 5
        st.ServiceName,
        COUNT(jc.JobCardID) AS TotalJobs
    FROM JobCards jc
        INNER JOIN ServiceTypes st ON jc.ServiceTypeID = st.ServiceTypeID
    WHERE jc.BranchID = @BranchID
    GROUP BY st.ServiceName
    ORDER BY COUNT(jc.JobCardID) DESC;
END;

GO
