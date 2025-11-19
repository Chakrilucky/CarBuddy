SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_Search]
(
    @SearchText NVARCHAR(150),
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 20
        CustomerID,
        FullName,
        MobileNumber
    FROM Customers
    WHERE BranchID = @BranchID
      AND (
            FullName LIKE '%' + @SearchText + '%' OR
            MobileNumber LIKE '%' + @SearchText + '%'
          )
    ORDER BY FullName;
END;

GO
