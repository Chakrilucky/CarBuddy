SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ServiceType_Add]
(
    @ServiceName NVARCHAR(200),
    @Category NVARCHAR(100) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ServiceTypes
    (
        ServiceName,
        Category,
        Description,
        IsActive,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @ServiceName,
        @Category,
        @Description,
        1,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS ServiceTypeID;
END;

GO
