SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_InsuranceSummary]
(
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    -- SUMMARY BY STATUS
    SELECT 
        COUNT(*) AS TotalClaims,
        SUM(CASE WHEN ic.ClaimStatus = 'Initiated' THEN 1 ELSE 0 END) AS Initiated,
        SUM(CASE WHEN ic.ClaimStatus = 'Surveyor Visit' THEN 1 ELSE 0 END) AS SurveyorVisit,
        SUM(CASE WHEN ic.ClaimStatus = 'Processing' THEN 1 ELSE 0 END) AS Processing,
        SUM(CASE WHEN ic.ClaimStatus = 'Completed' THEN 1 ELSE 0 END) AS Completed,
        SUM(CASE WHEN ic.ClaimStatus = 'Closed' THEN 1 ELSE 0 END) AS Closed
    FROM InsuranceClaims ic
    WHERE 
        ic.BranchID = @BranchID
        AND ic.CreatedDate BETWEEN @FromDate AND @ToDate;


    -- BREAKDOWN BY CLAIM TYPE (Accident, Theft, Other)
    SELECT 
        ic.ClaimType,
        COUNT(*) AS CountByType
    FROM InsuranceClaims ic
    WHERE 
        ic.BranchID = @BranchID
        AND ic.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        ic.ClaimType
    ORDER BY 
        CountByType DESC;


    -- COMPANY-WISE BREAKDOWN
    SELECT 
        ic.InsuranceCompanyID,
        COUNT(*) AS ClaimsByCompany
    FROM InsuranceClaims ic
    WHERE 
        ic.BranchID = @BranchID
        AND ic.CreatedDate BETWEEN @FromDate AND @ToDate
    GROUP BY 
        ic.InsuranceCompanyID
    ORDER BY 
        ClaimsByCompany DESC;
END

GO
