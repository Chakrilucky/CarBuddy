SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerFeedback_GetByJobCardID]
(
    @JobCardID INT,
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
        CF.Rating,
        CF.ServiceQualityRating,
        CF.CommunicationRating,
        CF.DeliveryTimeRating,
        CF.PricingRating,
        CF.FeedbackText,
        CF.Suggestions,
        CF.TechnicianID,
        U.FullName AS TechnicianName,
        CF.ReviewedByManager,
        CF.CreatedDate
    FROM CustomerFeedback CF
    LEFT JOIN Customers C ON CF.CustomerID = C.CustomerID
    LEFT JOIN Users U ON CF.TechnicianID = U.UserID
    WHERE CF.JobCardID = @JobCardID
      AND CF.BranchID = @BranchID;
END;

GO
