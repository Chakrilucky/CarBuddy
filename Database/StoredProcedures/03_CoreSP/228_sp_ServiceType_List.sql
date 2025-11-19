SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ServiceType_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ServiceTypeID,
        ServiceName,
        Category,
        Description,
        IsActive,
        CreatedDate,
        UpdatedDate
    FROM ServiceTypes
    WHERE BranchID = @BranchID
    ORDER BY ServiceName ASC;
END;

GO
