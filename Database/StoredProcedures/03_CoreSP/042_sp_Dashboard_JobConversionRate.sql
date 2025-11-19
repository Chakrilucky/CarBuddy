SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_JobConversionRate]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. TOTAL ENQUIRIES
    SELECT 
        COUNT(*) AS TotalEnquiries
    FROM Enquiries
    WHERE 
        BranchID = @BranchID
        AND EnquiryDate BETWEEN @FromDate AND @ToDate;


    -- 2. TOTAL ESTIMATES CREATED
    SELECT 
        COUNT(*) AS TotalEstimates
    FROM Estimates
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;


    -- 3. APPROVED ESTIMATES
    SELECT 
        COUNT(*) AS ApprovedEstimates
    FROM EstimateApprovals ea
    INNER JOIN Estimates e ON ea.EstimateID = e.EstimateID
    WHERE 
        e.BranchID = @BranchID
        AND ea.ApprovalStatus = 'Approved'
        AND ea.ApprovalDate BETWEEN @FromDate AND @ToDate;


    -- 4. TOTAL JOB CARDS CREATED
    SELECT 
        COUNT(*) AS TotalJobCards
    FROM JobCards
    WHERE 
        BranchID = @BranchID
        AND CreatedDate BETWEEN @FromDate AND @ToDate;
END

GO
