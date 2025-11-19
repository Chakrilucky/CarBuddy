SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_JobItems_Add]
    @JobCardID INT,
    @ItemType VARCHAR(50),      
    @ItemName NVARCHAR(200),
    @ItemDescription NVARCHAR(MAX),
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @IsInsuranceItem BIT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

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
    VALUES
    (
        @JobCardID,
        @ItemType,
        @ItemName,
        @ItemDescription,
        @Quantity,
        @UnitPrice,
        @IsInsuranceItem,
        NULL,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS JobItemID;
END;

GO
