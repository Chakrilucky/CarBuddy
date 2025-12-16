SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_Branches_List
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        BranchID,
        BranchName,
        City,
        State,
        AddressLine1,
        AddressLine2,
        Pincode,
        PhoneNumber,
        Email,
        CreatedDate
    FROM Branches
    ORDER BY BranchName;
END
GO
