SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Package_CopyItemsToJobCard]
(
    @JobCardID INT,
    @PackageID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------
    -- 1️⃣ Copy Labour (ItemType = Labour)
    -----------------------------------------
    INSERT INTO JobLabourTracking
    (
        JobCardID,
        TechnicianID,
        LabourType,
        Description,
        LabourHours,
        LabourRate,
        WorkStatus,
        StartTime,
        Notes,
        CreatedDate,
        BranchID
    )
    SELECT
        @JobCardID,
        NULL,                   -- technician is assigned later
        PI.ItemName,
        PI.ItemName,
        PI.Quantity,            -- quantity = hours
        PI.UnitPrice,           -- labour rate
        'Pending',
        GETDATE(),
        NULL,
        GETDATE(),
        @BranchID
    FROM PackageItems PI
    WHERE PI.PackageID = @PackageID
      AND PI.ItemType = 'Labour'
      AND PI.BranchID = @BranchID;

    -----------------------------------------
    -- 2️⃣ Copy Parts (ItemType = Part)
    -- IMPORTANT: Remove TotalPrice (computed)
    -----------------------------------------
    INSERT INTO JobItems
    (
        JobCardID,
        ItemType,
        ItemName,
        ItemDescription,
        Quantity,
        UnitPrice,
        IsInsuranceItem,
        IsApproved,
        CreatedDate,
        BranchID
    )
    SELECT
        @JobCardID,
        'Part',
        PI.ItemName,
        PI.ItemName,
        PI.Quantity,
        PI.UnitPrice,
        0,          -- not insurance item
        1,          -- approved
        GETDATE(),
        @BranchID
    FROM PackageItems PI
    WHERE PI.PackageID = @PackageID
      AND PI.ItemType = 'Part'
      AND PI.BranchID = @BranchID;

END;

GO
