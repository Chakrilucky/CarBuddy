SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_Labour_Delete]
(
    @LabourID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM JobLabourTracking
    WHERE LabourID = @LabourID
      AND BranchID = @BranchID;
END;

GO
