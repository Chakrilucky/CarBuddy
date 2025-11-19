SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_CustomerSatisfactionSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;


    -----------------------------------------------------
    -- 1. OVERALL RATING SUMMARY
    -----------------------------------------------------
    SELECT 
        COUNT(*) AS TotalFeedbacks,
        AVG(CAST(Rating AS DECIMAL(5,2))) AS AverageRating,
        SUM(CASE WHEN Rating >= 4 THEN 1 ELSE 0 END) AS PositiveRatings,
        SUM(CASE WHEN Rating = 3 THEN 1 ELSE 0 END) AS NeutralRatings,
        SUM(CASE WHEN Rating <= 2 THEN 1 ELSE 0 END) AS NegativeRatings
    FROM Feedback
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;



    -----------------------------------------------------
    -- 2. SERVICE TYPE WISE RATING SUMMARY
    -----------------------------------------------------
    SELECT 
        st.ServiceName,
        AVG(CAST(f.Rating AS DECIMAL(5,2))) AS AvgRating,
        COUNT(f.FeedbackID) AS TotalFeedbacks
    FROM Feedback f
    INNER JOIN JobCards j ON f.JobCardID = j.JobCardID
    INNER JOIN ServiceTypes st ON j.ServiceTypeID = st.ServiceTypeID
    WHERE 
        f.BranchID = @BranchID
        AND f.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        st.ServiceName
    ORDER BY 
        AvgRating DESC;



    -----------------------------------------------------
    -- 3. TECHNICIAN WISE RATING SUMMARY
    -----------------------------------------------------
    SELECT 
        u.UserID,
        u.FullName,
        AVG(CAST(f.Rating AS DECIMAL(5,2))) AS AvgRating,
        COUNT(f.FeedbackID) AS TotalFeedbacks
    FROM Feedback f
    INNER JOIN JobCards j ON f.JobCardID = j.JobCardID
    INNER JOIN Users u ON j.AssignedTechnicianID = u.UserID
    WHERE 
        f.BranchID = @BranchID
        AND f.CreatedDate BETWEEN @FromDate AND @ToDate
        AND u.Role = 'Technician'
    GROUP BY 
        u.UserID, u.FullName
    ORDER BY 
        AvgRating DESC;
END

GO
