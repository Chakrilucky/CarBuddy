SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Estimate_Approve]
    @EstimateID INT,
    @ApprovedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Estimates
    SET 
        Status = 'Approved',
        ApprovedBy = @ApprovedBy,
        ApprovedDate = GETDATE()
    WHERE EstimateID = @EstimateID
      AND BranchID = @BranchID;

    SELECT 'Estimate Approved' AS Status;
END;

GO
