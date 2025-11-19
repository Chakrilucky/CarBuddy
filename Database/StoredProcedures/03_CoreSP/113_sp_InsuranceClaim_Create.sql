SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceClaim_Create]
(
    @JobCardID          INT,
    @PolicyID           INT,
    @InsuranceCompanyID INT,
    @ClaimNumber        NVARCHAR(100),
    @ClaimType          VARCHAR(50),
    @ClaimStatus        VARCHAR(50),
    @SurveyorName       NVARCHAR(100),
    @SurveyorMobile     VARCHAR(20),
    @SurveyorVisitDate  DATETIME2,
    @ApprovedAmount     DECIMAL(18,2),
    @RejectedReason     NVARCHAR(MAX),
    @Notes              NVARCHAR(MAX),
    @BranchID           INT,
    @CreatedBy          INT,
    @PolicyNumber       NVARCHAR(100),
    @EstimateAmount     DECIMAL(18,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaims
    (
        JobCardID, PolicyID, InsuranceCompanyID, ClaimNumber, ClaimType,
        ClaimStatus, SurveyorName, SurveyorMobile, SurveyorVisitDate,
        ApprovedAmount, RejectedReason, Notes, CreatedDate, BranchID,
        CreatedBy, PolicyNumber, EstimateAmount
    )
    VALUES
    (
        @JobCardID, @PolicyID, @InsuranceCompanyID, @ClaimNumber, @ClaimType,
        @ClaimStatus, @SurveyorName, @SurveyorMobile, @SurveyorVisitDate,
        @ApprovedAmount, @RejectedReason, @Notes, GETDATE(), @BranchID,
        @CreatedBy, @PolicyNumber, @EstimateAmount
    );

    SELECT SCOPE_IDENTITY() AS NewInsuranceClaimID;
END;

GO
