SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceSurveyorVisit_Delete]
(
    @SurveyVisitID INT,
    @BranchID INT
)
AS
BEGIN
    DELETE FROM InsuranceSurveyorVisits
    WHERE SurveyVisitID = @SurveyVisitID
      AND BranchID = @BranchID;
END;

GO
