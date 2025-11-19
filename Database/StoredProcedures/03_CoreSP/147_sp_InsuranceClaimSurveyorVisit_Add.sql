SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSurveyorVisit_Add]
(
    @InsuranceClaimID INT,
    @VisitDate DATETIME2,
    @VisitType VARCHAR(50),
    @SurveyorName NVARCHAR(150),
    @SurveyorMobile VARCHAR(15),
    @VisitStatus VARCHAR(50),
    @Notes NVARCHAR(MAX) = NULL,
    @PhotoPath1 NVARCHAR(MAX) = NULL,
    @PhotoPath2 NVARCHAR(MAX) = NULL,
    @PhotoPath3 NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceSurveyorVisits
    (
        InsuranceClaimID,
        VisitDate,
        VisitType,
        SurveyorName,
        SurveyorMobile,
        VisitStatus,
        Notes,
        PhotoPath1,
        PhotoPath2,
        PhotoPath3,
        CreatedDate,
        UpdatedDate,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        @VisitDate,
        @VisitType,
        @SurveyorName,
        @SurveyorMobile,
        @VisitStatus,
        @Notes,
        @PhotoPath1,
        @PhotoPath2,
        @PhotoPath3,
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewSurveyVisitID;
END;

GO
