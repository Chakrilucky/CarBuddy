SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ServiceType_Update]
(
    @ServiceTypeID INT,
    @ServiceName NVARCHAR(200),
    @Category NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ServiceTypes
    SET 
        ServiceName = @ServiceName,
        Category = @Category,
        Description = @Description,
        IsActive = @IsActive,
        UpdatedDate = GETDATE()
    WHERE
        ServiceTypeID = @ServiceTypeID
        AND BranchID = @BranchID;
END;

GO
