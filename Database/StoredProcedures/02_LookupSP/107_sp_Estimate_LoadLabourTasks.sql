SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_LoadLabourTasks]
(
    @ServiceTypeID INT,
    @BranchID INT
)
AS
BEGIN
    EXEC sp_LabourTasks_GetByServiceType @ServiceTypeID, @BranchID;
END;

GO
