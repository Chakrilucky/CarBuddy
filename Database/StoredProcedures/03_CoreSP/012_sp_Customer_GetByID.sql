SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Customer_GetByID]
(
    @CustomerID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Customers
    WHERE CustomerID = @CustomerID
      AND BranchID = @BranchID;
END;

GO
