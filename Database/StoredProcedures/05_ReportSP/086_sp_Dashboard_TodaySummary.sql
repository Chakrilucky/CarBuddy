SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_TodaySummary]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    -- 1. TODAY JOB SUMMARY
    SELECT 
        SUM(CASE WHEN CAST(j.CreatedDate AS DATE) = @Today THEN 1 ELSE 0 END) AS JobsCreatedToday,
        SUM(CASE WHEN CAST(j.CompletedOn AS DATE) = @Today THEN 1 ELSE 0 END) AS JobsCompletedToday,
        SUM(CASE WHEN j.JobStatus = 'Delivered'
                  AND CAST(j.ActualDelivery AS DATE) = @Today THEN 1 ELSE 0 END) AS JobsDeliveredToday,
        SUM(CASE WHEN j.JobStatus <> 'Delivered'
                  AND CAST(j.EstimatedDelivery AS DATE) = @Today THEN 1 ELSE 0 END) AS PendingDeliveryToday
    FROM JobCards j
    WHERE 
        j.BranchID = @BranchID;


    -- 2. TODAY REVENUE
    SELECT 
        SUM(i.NetAmount) AS TodayRevenue
    FROM Invoices i
    WHERE 
        i.BranchID = @BranchID
        AND CAST(i.CreatedDate AS DATE) = @Today;


    -- 3. TODAY NEW CUSTOMERS
    SELECT 
        COUNT(*) AS NewCustomersToday
    FROM Customers
    WHERE 
        BranchID = @BranchID
        AND CAST(CreatedDate AS DATE) = @Today;


    -- 4. TODAY ENQUIRIES (optional)
    SELECT 
        COUNT(*) AS EnquiriesToday
    FROM Enquiries
    WHERE 
        BranchID = @BranchID
        AND CAST(EnquiryDate AS DATE) = @Today;
END

GO
