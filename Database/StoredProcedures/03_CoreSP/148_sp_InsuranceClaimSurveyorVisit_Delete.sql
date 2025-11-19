SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSurveyorVisit_Delete]
(
    @SurveyVisitID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM InsuranceSurveyorVisits
    WHERE 
        SurveyVisitID = @SurveyVisitID
        AND BranchID = @BranchID;

    SELECT 'Deleted Successfully' AS Result;
END;

GO
