SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobCard_CreateFromBooking]
(
    @BookingID INT,
    @OdometerReading INT = NULL,
    @FuelLevel VARCHAR(20) = NULL,
    @Remarks NVARCHAR(MAX) = NULL,
    @EstimatedDelivery DATETIME2 = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------
    -- 1) Fetch booking details
    -----------------------------------------------------------
    DECLARE 
        @CustomerID INT,
        @VehicleID INT,
        @PriorityTypeID INT,
        @HasTowing BIT,
        @TowingRequestID INT;

    SELECT
        @CustomerID = CustomerID,
        @VehicleID = VehicleID,
        @PriorityTypeID = PriorityTypeID,
        @HasTowing = HasTowing,
        @TowingRequestID = TowingRequestID
    FROM AppointmentBookings
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;

    IF @CustomerID IS NULL
    BEGIN
        RAISERROR('Invalid BookingID for this branch.', 16, 1);
        RETURN;
    END

    -----------------------------------------------------------
    -- 2) Generate JobCardNumber
    -----------------------------------------------------------
    DECLARE @JobCardNumber VARCHAR(50);

    SET @JobCardNumber = 
        'JC-' + CONVERT(VARCHAR(6), GETDATE(), 112) + '-' +
        RIGHT('0000' + CAST((SELECT ISNULL(MAX(JobCardID),0)+1 FROM JobCards) AS VARCHAR), 4);

    -----------------------------------------------------------
    -- 3) Insert JobCard
    -----------------------------------------------------------
    INSERT INTO JobCards
    (
        CustomerID,
        VehicleID,
        ServiceTypeID,
        PriorityTypeID,
        JobCardNumber,
        OdometerReading,
        FuelLevel,
        HasTowing,
        TowingNotes,
        EstimatedDelivery,
        JobStatus,
        Remarks,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @CustomerID,
        @VehicleID,
        NULL,                   -- service type not yet selected
        @PriorityTypeID,
        @JobCardNumber,
        @OdometerReading,
        @FuelLevel,
        @HasTowing,
        CASE WHEN @HasTowing = 1 
             THEN CONCAT('Linked to TowingRequestID: ', @TowingRequestID)
             ELSE NULL 
        END,
        @EstimatedDelivery,
        'PendingInspection',
        @Remarks,
        GETDATE(),
        @BranchID
    );

    DECLARE @JobCardID INT = SCOPE_IDENTITY();

    -----------------------------------------------------------
    -- 4) Insert Initial Stage (Stage 1)
    -----------------------------------------------------------
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
        1,
        'PendingInspection',
        'InProgress',
        GETDATE(),
        NULL,
        @BranchID
    );

    -----------------------------------------------------------
    -- 5) Update Booking Status
    -----------------------------------------------------------
    UPDATE AppointmentBookings
    SET 
        BookingStatus = 'ConvertedToJobCard',
        UpdatedDate = GETDATE()
    WHERE BookingID = @BookingID
      AND BranchID = @BranchID;

    -----------------------------------------------------------
    -- 6) Return new JobCard
    -----------------------------------------------------------
    SELECT 
        @JobCardID AS JobCardID,
        @JobCardNumber AS JobCardNumber;

END;

GO
