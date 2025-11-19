SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerFeedback_List]
(
    @CustomerID INT = NULL,
    @TechnicianID INT = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CF.FeedbackID,
        CF.JobCardID,
        CF.CustomerID,
        C.FullName AS CustomerName,
        CF.TechnicianID,
        U.FullName AS TechnicianName,

        CF.Rating,
        CF.ServiceQualityRating,
        CF.CommunicationRating,
        CF.DeliveryTimeRating,
        CF.PricingRating,

        CF.FeedbackText,
        CF.Suggestions,

        CF.ReviewedByManager,
        CF.CreatedDate
    FROM CustomerFeedback CF
    LEFT JOIN Customers C ON CF.CustomerID = C.CustomerID
    LEFT JOIN Users U ON CF.TechnicianID = U.UserID
    WHERE 
        CF.BranchID = @BranchID
        AND (@CustomerID IS NULL OR CF.CustomerID = @CustomerID)
        AND (@TechnicianID IS NULL OR CF.TechnicianID = @TechnicianID)
    ORDER BY CF.CreatedDate DESC, CF.FeedbackID DESC;
END;

GO
