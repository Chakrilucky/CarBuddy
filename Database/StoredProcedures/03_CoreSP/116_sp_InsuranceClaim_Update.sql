SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceClaim_Update]
(
    @InsuranceClaimID   INT,
    @ClaimNumber        NVARCHAR(100),
    @ClaimType          VARCHAR(50),
    @ClaimStatus        VARCHAR(50),
    @SurveyorName       NVARCHAR(100),
    @SurveyorMobile     VARCHAR(20),
    @SurveyorVisitDate  DATETIME2,
    @ApprovedAmount     DECIMAL(18,2),
    @RejectedReason     NVARCHAR(MAX),
    @Notes              NVARCHAR(MAX),
    @EstimateAmount     DECIMAL(18,2),
    @PolicyNumber       NVARCHAR(100),
    @BranchID           INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InsuranceClaims
    SET
        ClaimNumber       = @ClaimNumber,
        ClaimType         = @ClaimType,
        ClaimStatus       = @ClaimStatus,
        SurveyorName      = @SurveyorName,
        SurveyorMobile    = @SurveyorMobile,
        SurveyorVisitDate = @SurveyorVisitDate,
        ApprovedAmount    = @ApprovedAmount,
        RejectedReason    = @RejectedReason,
        Notes             = @Notes,
        EstimateAmount    = @EstimateAmount,
        PolicyNumber      = @PolicyNumber,
        UpdatedDate       = GETDATE(),
        BranchID          = @BranchID
    WHERE InsuranceClaimID = @InsuranceClaimID;
END;

GO
