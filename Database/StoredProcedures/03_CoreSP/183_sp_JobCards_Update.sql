SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCards_Update]
    @JobCardID INT,
    @ServiceTypeID INT,
    @PriorityTypeID INT,
    @OdometerReading INT = NULL,
    @FuelLevel VARCHAR(20) = NULL,
    @HasTowing BIT = 0,
    @TowingNotes NVARCHAR(300) = NULL,
    @EstimatedDelivery DATETIME2 = NULL,
    @ActualDelivery DATETIME2 = NULL,
    @AssignedTechnicianID INT = NULL,
    @JobStatus VARCHAR(50),
    @Remarks NVARCHAR(MAX),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE JobCards
    SET
        ServiceTypeID = @ServiceTypeID,
        PriorityTypeID = @PriorityTypeID,
        OdometerReading = @OdometerReading,
        FuelLevel = @FuelLevel,
        HasTowing = @HasTowing,
        TowingNotes = @TowingNotes,
        EstimatedDelivery = @EstimatedDelivery,
        ActualDelivery = @ActualDelivery,
        AssignedTechnicianID = @AssignedTechnicianID,
        JobStatus = @JobStatus,
        Remarks = @Remarks,
        UpdatedDate = GETDATE()
    WHERE JobCardID = @JobCardID
      AND BranchID = @BranchID;
END;

GO
