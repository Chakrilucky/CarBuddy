SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSurveyorVisit_Update]
(
    @SurveyVisitID INT,
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

    UPDATE InsuranceSurveyorVisits
    SET
        VisitDate      = @VisitDate,
        VisitType      = @VisitType,
        SurveyorName   = @SurveyorName,
        SurveyorMobile = @SurveyorMobile,
        VisitStatus    = @VisitStatus,
        Notes          = @Notes,
        PhotoPath1     = @PhotoPath1,
        PhotoPath2     = @PhotoPath2,
        PhotoPath3     = @PhotoPath3,
        UpdatedDate    = GETDATE()
    WHERE 
        SurveyVisitID = @SurveyVisitID
        AND BranchID = @BranchID;

    SELECT 'Updated Successfully' AS Result;
END;

GO
