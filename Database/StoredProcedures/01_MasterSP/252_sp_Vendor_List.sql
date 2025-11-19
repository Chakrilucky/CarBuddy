SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Vendor_List]
(
    @BranchID INT,
    @Search NVARCHAR(200) = NULL,     -- optional search text
    @ShowInactive BIT = 1             -- 1 = show all, 0 = only active
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
    WHERE BranchID = @BranchID
      AND (
            @ShowInactive = 1 
            OR IsActive = 1
          )
      AND (
            @Search IS NULL
            OR VendorName LIKE '%' + @Search + '%'
            OR ContactPerson LIKE '%' + @Search + '%'
            OR MobileNumber LIKE '%' + @Search + '%'
            OR City LIKE '%' + @Search + '%'
            OR State LIKE '%' + @Search + '%'
            OR GSTNumber LIKE '%' + @Search + '%'
          )
    ORDER BY VendorName ASC;
END;

GO
