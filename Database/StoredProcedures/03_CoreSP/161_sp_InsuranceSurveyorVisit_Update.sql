SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceSurveyorVisit_Update]
(
    @SurveyVisitID INT,
    @VisitDate DATETIME2,
    @VisitType VARCHAR(50),
    @SurveyorName NVARCHAR(150),
    @SurveyorMobile VARCHAR(20),
    @VisitStatus VARCHAR(50),
    @Notes NVARCHAR(500),
    @PhotoPath1 NVARCHAR(300),
    @PhotoPath2 NVARCHAR(300),
    @PhotoPath3 NVARCHAR(300),
    @BranchID INT
)
AS
BEGIN
    UPDATE InsuranceSurveyorVisits
    SET 
        VisitDate = @VisitDate,
        VisitType = @VisitType,
        SurveyorName = @SurveyorName,
        SurveyorMobile = @SurveyorMobile,
        VisitStatus = @VisitStatus,
        Notes = @Notes,
        PhotoPath1 = @PhotoPath1,
        PhotoPath2 = @PhotoPath2,
        PhotoPath3 = @PhotoPath3,
        UpdatedDate = GETDATE()
    WHERE SurveyVisitID = @SurveyVisitID
      AND BranchID = @BranchID;
END;

GO
