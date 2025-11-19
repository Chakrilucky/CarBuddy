SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSurveyorVisit_List]
(
    @InsuranceClaimID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.SurveyVisitID,
        v.InsuranceClaimID,
        v.VisitDate,
        v.VisitType,
        v.SurveyorName,
        v.SurveyorMobile,
        v.VisitStatus,
        v.Notes,
        v.PhotoPath1,
        v.PhotoPath2,
        v.PhotoPath3,
        v.CreatedDate,
        v.UpdatedDate,
        v.BranchID
    FROM InsuranceSurveyorVisits v
    WHERE 
        v.InsuranceClaimID = @InsuranceClaimID
        AND v.BranchID = @BranchID
    ORDER BY v.VisitDate DESC, v.SurveyVisitID DESC;
END;

GO
