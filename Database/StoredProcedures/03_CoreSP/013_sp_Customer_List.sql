SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_List]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CustomerID,
        FullName,
        MobileNumber,
        AlternateMobile,
        Email,
        City,
        State,
        Pincode,
        GSTNumber,
        CreatedDate,
        IsActive
    FROM Customers
    WHERE BranchID = @BranchID
    ORDER BY CustomerID DESC;
END;

GO
