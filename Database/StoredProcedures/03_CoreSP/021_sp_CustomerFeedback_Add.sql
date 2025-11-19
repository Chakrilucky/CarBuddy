SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerFeedback_Add]
(
    @JobCardID INT,
    @CustomerID INT,
    @Rating INT,
    @ServiceQualityRating INT = NULL,
    @CommunicationRating INT = NULL,
    @DeliveryTimeRating INT = NULL,
    @PricingRating INT = NULL,
    @FeedbackText NVARCHAR(MAX) = NULL,
    @Suggestions NVARCHAR(MAX) = NULL,
    @TechnicianID INT = NULL,
    @ReviewedByManager BIT = 0,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO CustomerFeedback
    (
        JobCardID,
        CustomerID,
        Rating,
        ServiceQualityRating,
        CommunicationRating,
        DeliveryTimeRating,
        PricingRating,
        FeedbackText,
        Suggestions,
        TechnicianID,
        ReviewedByManager,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @JobCardID,
        @CustomerID,
        @Rating,
        @ServiceQualityRating,
        @CommunicationRating,
        @DeliveryTimeRating,
        @PricingRating,
        @FeedbackText,
        @Suggestions,
        @TechnicianID,
        @ReviewedByManager,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS FeedbackID;
END;

GO
