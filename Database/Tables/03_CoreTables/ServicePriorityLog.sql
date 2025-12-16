DROP TABLE IF EXISTS ServicePriorityLog;
GO

CREATE TABLE ServicePriorityLog (
    PriorityLogId INT IDENTITY(1,1) PRIMARY KEY,

    JobCardId INT NOT NULL,
    PriorityType NVARCHAR(20) NOT NULL
        CHECK (PriorityType IN ('Normal', 'Premium')),

    ExtraCharge DECIMAL(10,2) NOT NULL DEFAULT 0,
    AppliedByUserId INT NOT NULL,
    AppliedDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_SPL_JobCard
        FOREIGN KEY (JobCardId)
        REFERENCES JobCards(JobCardID),

    CONSTRAINT FK_SPL_User
        FOREIGN KEY (AppliedByUserId)
        REFERENCES Users(UserID)
);
GO

CREATE INDEX IDX_SPL_JobCardId
ON ServicePriorityLog(JobCardId);

