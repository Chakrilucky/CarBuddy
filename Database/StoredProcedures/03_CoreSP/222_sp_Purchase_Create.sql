SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Purchase_Create]
    @PartID INT,
    @VendorID INT = NULL,
    @InvoiceNumber NVARCHAR(100) = NULL,
    @PurchaseDate DATETIME2 = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PurchaseDate IS NULL
        SET @PurchaseDate = GETDATE();

    INSERT INTO InventoryPurchases
    (
        PartID, VendorID, InvoiceNumber, PurchaseDate,
        CreatedDate, BranchID
    )
    VALUES
    (
        @PartID, @VendorID, @InvoiceNumber, @PurchaseDate,
        GETDATE(), @BranchID
    );

    SELECT SCOPE_IDENTITY() AS PurchaseID;
END;

GO
