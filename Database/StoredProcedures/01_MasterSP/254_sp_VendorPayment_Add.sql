SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VendorPayment_Add]
(
    @VendorID INT,
    @PurchaseID INT = NULL,          -- Optional linking to purchase
    @PaymentMethod VARCHAR(50),
    @AmountPaid DECIMAL(18,2),
    @ReferenceNumber NVARCHAR(150) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO VendorPayments
    (
        VendorID,
        PurchaseID,
        PaymentMethod,
        AmountPaid,
        ReferenceNumber,
        Notes,
        PaymentDate,
        CreatedDate,
        BranchID
    )
    VALUES
    (
        @VendorID,
        @PurchaseID,
        @PaymentMethod,
        @AmountPaid,
        @ReferenceNumber,
        @Notes,
        GETDATE(),       -- Payment Date = Now
        GETDATE(),       -- Created Date = Now
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS VendorPaymentID;
END;

GO
