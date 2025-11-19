SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vendor_Get]
(
    @VendorID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        VendorID,
        VendorName,
        ContactPerson,
        MobileNumber,
        AlternateMobile,
        Email,
        AddressLine1,
        AddressLine2,
        City,
        State,
        Pincode,
        GSTNumber,
        PANNumber,
        PaymentTerms,
        Notes,
        IsActive,
        CreatedDate,
        UpdatedDate,
        BranchID
    FROM Vendors
    WHERE VendorID = @VendorID
      AND BranchID = @BranchID;
END;

GO
