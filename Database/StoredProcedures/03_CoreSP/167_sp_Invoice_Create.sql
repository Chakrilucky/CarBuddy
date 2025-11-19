SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Invoice_Create]
    @JobCardID INT,
    @InvoiceDate DATETIME2,
    @CreatedByUserID INT = NULL,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobInvoices
    (
        JobCardID,
        InvoiceNumber,
        InvoiceDate,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @JobCardID,
        CONCAT('INV-', @JobCardID, '-', FORMAT(GETDATE(), 'yyyyMMddHHmmss')),
        @InvoiceDate,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS InvoiceID;
END;

GO
