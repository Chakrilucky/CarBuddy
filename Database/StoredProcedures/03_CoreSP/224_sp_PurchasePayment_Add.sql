SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PurchasePayment_Add]
(
    @VendorID INT = NULL,
    @PurchaseID INT = NULL,
    @PaymentMethod VARCHAR(50),
    @AmountPaid DECIMAL(18,2),
    @ReferenceNumber NVARCHAR(150) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- optional: validate PurchaseID/VendorID existence (safe selective checks)
    IF @PurchaseID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM InventoryPurchases WHERE PurchaseID = @PurchaseID AND BranchID = @BranchID)
        BEGIN
            RAISERROR('Invalid PurchaseID for this branch.',16,1);
            RETURN;
        END
    END

    IF @VendorID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Vendors WHERE VendorID = @VendorID AND BranchID = @BranchID)
        BEGIN
            RAISERROR('Invalid VendorID for this branch.',16,1);
            RETURN;
        END
    END

    INSERT INTO VendorPayments
    (
        VendorID,
        PurchaseID,
        PaymentDate,
        PaymentMethod,
        AmountPaid,
        ReferenceNumber,
        Notes,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @VendorID,
        @PurchaseID,
        GETDATE(),
        @PaymentMethod,
        @AmountPaid,
        @ReferenceNumber,
        @Notes,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VendorPaymentID;
END;

GO
