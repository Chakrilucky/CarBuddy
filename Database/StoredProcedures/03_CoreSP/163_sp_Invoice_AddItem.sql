SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Invoice_AddItem]
(
    @InvoiceID INT,
    @ItemType VARCHAR(50),
    @ItemName NVARCHAR(200),
    @ItemDescription NVARCHAR(MAX) = NULL,
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @IsTaxable BIT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobInvoiceItems
    (
        InvoiceID,
        ItemType,
        ItemName,
        ItemDescription,
        Quantity,
        UnitPrice,
        IsTaxable,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @InvoiceID,
        @ItemType,
        @ItemName,
        @ItemDescription,
        @Quantity,
        @UnitPrice,
        @IsTaxable,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS InvoiceItemID;
END;

GO
