SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_VisitHistory_Add]
(
    @CustomerID INT,
    @VehicleID INT,
    @JobCardID INT = NULL,
    @VisitType VARCHAR(50),
    @VisitDate DATETIME2,
    @OdometerReading INT = NULL,
    @Complaints NVARCHAR(MAX) = NULL,
    @Observations NVARCHAR(MAX) = NULL,
    @AttendedByUserID INT = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------
    -- Validate Customer
    -------------------------------------------------
    IF NOT EXISTS (
        SELECT 1 FROM Customers 
        WHERE CustomerID = @CustomerID AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('Invalid CustomerID for this branch.', 16, 1);
        RETURN;
    END

    -------------------------------------------------
    -- Validate Vehicle
    -------------------------------------------------
    IF NOT EXISTS (
        SELECT 1 FROM Vehicles 
        WHERE VehicleID = @VehicleID AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('Invalid VehicleID for this branch.', 16, 1);
        RETURN;
    END

    -------------------------------------------------
    -- Insert Visit History
    -------------------------------------------------
    INSERT INTO VehicleVisitHistory
    (
        VehicleID,
        CustomerID,
        JobCardID,
        VisitType,
        VisitDate,
        OdometerReading,
        Complaints,
        Observations,
        AttendedByUserID,
        Notes,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @VehicleID,
        @CustomerID,
        @JobCardID,
        @VisitType,
        @VisitDate,
        @OdometerReading,
        @Complaints,
        @Observations,
        @AttendedByUserID,
        @Notes,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VisitID;
END;

GO
