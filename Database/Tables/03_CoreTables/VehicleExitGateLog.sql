DROP TABLE IF EXISTS VehicleExitGateLog;
GO

CREATE TABLE VehicleExitGateLog (
    ExitLogId INT IDENTITY(1,1) PRIMARY KEY,

    JobCardId INT NOT NULL,          -- FK → JobCards.JobCardID
    VehicleID INT NOT NULL,          -- FK → Vehicles.VehicleID

    ExitType NVARCHAR(20) NOT NULL
        CHECK (ExitType IN ('TestDrive', 'Delivery')),

    PaymentCleared BIT NOT NULL DEFAULT 0,
    InsuranceCleared BIT NOT NULL DEFAULT 1,

    ScannedByUserId INT NOT NULL,
    ExitDateTime DATETIME NOT NULL DEFAULT GETDATE(),
    Remarks NVARCHAR(250) NULL,

    CONSTRAINT FK_VEGL_JobCard
        FOREIGN KEY (JobCardId)
        REFERENCES JobCards(JobCardID),

    CONSTRAINT FK_VEGL_Vehicle
        FOREIGN KEY (VehicleID)
        REFERENCES Vehicles(VehicleID)
);
GO


CREATE INDEX IDX_VEGL_JobCardId
ON VehicleExitGateLog(JobCardId);
GO

