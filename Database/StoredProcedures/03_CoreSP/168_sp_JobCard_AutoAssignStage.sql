SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_AutoAssignStage]
(
    @JobCardID INT,
    @StageName VARCHAR(100),
    @StageOrder INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobCardStages
    (
        JobCardId,
        StageOrder,
        StageName,
        Status,
        UpdatedOn,
        UpdatedBy,
        BranchID
    )
    VALUES
    (
        @JobCardID,
        @StageOrder,
        @StageName,
        'InProgress',
        GETDATE(),
        NULL,
        @BranchID
    );
END;

GO
