DROP TABLE IF EXISTS TechnicianWorkLog;
GO

CREATE TABLE TechnicianWorkLog (
    WorkLogId INT IDENTITY(1,1) PRIMARY KEY,

    JobCardId INT NOT NULL,        -- FK → JobCards
    TechnicianUserId INT NOT NULL, -- FK → Users / Technicians

    StartTime DATETIME NOT NULL,
    EndTime DATETIME NULL,

    WorkRemarks NVARCHAR(250) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_TWL_JobCard
        FOREIGN KEY (JobCardId)
        REFERENCES JobCards(JobCardID)
);
GO

ALTER TABLE TechnicianWorkLog
ADD CONSTRAINT FK_TWL_Technician
FOREIGN KEY (TechnicianUserId)
REFERENCES Users(UserID);


CREATE INDEX IDX_TWL_JobCardId
ON TechnicianWorkLog(JobCardId);

CREATE INDEX IDX_TWL_Technician
ON TechnicianWorkLog(TechnicianUserId);

