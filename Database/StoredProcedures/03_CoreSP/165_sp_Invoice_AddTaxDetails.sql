SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Invoice_AddTaxDetails]
(
    @InvoiceID INT,
    @JobCardID INT,
    @LabourTaxPercent DECIMAL(5,2) = NULL,
    @PartsTaxPercent DECIMAL(5,2) = NULL,
    @TowingTaxPercent DECIMAL(5,2) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO JobTaxDetails
    (
        JobCardID,
        InvoiceID,
        LabourTaxPercentage,
        PartsTaxPercentage,
        TowingTaxPercentage,
        CreatedDate
    )
    VALUES
    (
        @JobCardID,
        @InvoiceID,
        @LabourTaxPercent,
        @PartsTaxPercent,
        @TowingTaxPercent,
        GETDATE()
    );
END;

GO
