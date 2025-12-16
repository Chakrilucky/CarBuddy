CREATE TABLE JobCardMaterialUsage (
    UsageId INT IDENTITY(1,1) PRIMARY KEY,
    JobCardId INT NOT NULL,
    PartID INT NOT NULL,                 
    QuantityUsed DECIMAL(10,2) NOT NULL,
    Unit NVARCHAR(20) NOT NULL,
    UsedByUserId INT NOT NULL,
    UsedDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_JCMU_JobCard
        FOREIGN KEY (JobCardId)
        REFERENCES JobCards(JobCardID),

    CONSTRAINT FK_JCMU_InventoryPart
        FOREIGN KEY (PartID)
        REFERENCES InventoryParts(PartID)
);
