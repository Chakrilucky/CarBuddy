SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCards_Create]
    @CustomerID INT,
    @VehicleID INT,
    @ServiceTypeID INT,
    @PriorityTypeID INT,
    @OdometerReading INT = NULL,
    @FuelLevel VARCHAR(20) = NULL,
    @HasTowing BIT = 0,
    @TowingNotes NVARCHAR(300) = NULL,
    @EstimatedDelivery DATETIME2 = NULL,
    @Remarks NVARCHAR(MAX) = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @JobCardNumber VARCHAR(30);

        -- Auto JobCardNumber format:
        -- JC-[BranchID]-YYYYMMDD-[Sequence]
        DECLARE @Today VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112);

        DECLARE @Seq INT = (
            SELECT ISNULL(MAX(JobCardID), 0) + 1 
            FROM JobCards 
            WHERE BranchID = @BranchID
        );

        SET @JobCardNumber = 'JC-' + CAST(@BranchID AS VARCHAR) + '-' + @Today + '-' + CAST(@Seq AS VARCHAR);

        INSERT INTO JobCards
        (
            CustomerID, VehicleID, ServiceTypeID, PriorityTypeID,
            JobCardNumber, OdometerReading, FuelLevel, HasTowing, TowingNotes,
            EstimatedDelivery, JobStatus, Remarks, InsuranceClaimID,
            CreatedDate, BranchID
        )
        VALUES
        (
            @CustomerID, @VehicleID, @ServiceTypeID, @PriorityTypeID,
            @JobCardNumber, @OdometerReading, @FuelLevel, @HasTowing, @TowingNotes,
            @EstimatedDelivery, 'Created', @Remarks, NULL,
            GETDATE(), @BranchID
        );

        DECLARE @NewJobCardID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT @NewJobCardID AS JobCardID, @JobCardNumber AS JobCardNumber;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO
