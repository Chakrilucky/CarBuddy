SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InsuranceClaimAnalytics]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------------
    -- 1. TOTAL CLAIM SUMMARY
    ------------------------------------------------------------------------
    SELECT 
        COUNT(*) AS TotalClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Approved' THEN 1 ELSE 0 END) AS ApprovedClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Rejected' THEN 1 ELSE 0 END) AS RejectedClaims
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON c.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate;



    ------------------------------------------------------------------------
    -- 2. CLAIM STATUS BREAKDOWN
    ------------------------------------------------------------------------
    SELECT 
        c.ClaimStatus,
        COUNT(*) AS Total
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON c.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        c.ClaimStatus;



    ------------------------------------------------------------------------
    -- 3. INSURANCE COMPANY WISE CLAIM SUMMARY
    ------------------------------------------------------------------------
    SELECT 
        ic.CompanyName,
        COUNT(c.InsuranceClaimID) AS TotalClaims,
        SUM(CASE WHEN c.ClaimStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingClaims
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON c.JobCardID = j.JobCardID
    INNER JOIN InsuranceCompanies ic ON ic.InsuranceCompanyID = c.InsuranceCompanyID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        ic.CompanyName
    ORDER BY 
        TotalClaims DESC;



    ------------------------------------------------------------------------
    -- 4. SURVEYOR VISIT DETAILS
    ------------------------------------------------------------------------
    SELECT 
        c.InsuranceClaimID,
        c.JobCardID,
        c.SurveyorName,
        c.SurveyorMobile,
        c.SurveyorVisitDate,
        c.ClaimStatus
    FROM InsuranceClaims c
    INNER JOIN JobCards j ON c.JobCardID = j.JobCardID
    WHERE 
        j.BranchID = @BranchID
        AND j.CreatedDate BETWEEN @FromDate AND @ToDate
    ORDER BY 
        c.SurveyorVisitDate DESC;

END

GO
