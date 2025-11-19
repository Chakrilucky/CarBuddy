SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimPayment_Delete]
(
    @ClaimPaymentID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM InsuranceClaimPayments
    WHERE ClaimPaymentID = @ClaimPaymentID
      AND BranchID = @BranchID;
END;

GO
