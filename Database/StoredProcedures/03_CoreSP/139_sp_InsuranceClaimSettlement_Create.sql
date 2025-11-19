SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimSettlement_Create]
(
    @InsuranceClaimID INT,
    @TotalRequested DECIMAL(18,2),
    @TotalApproved DECIMAL(18,2),
    @CustomerPayable DECIMAL(18,2),
    @InsurancePayable DECIMAL(18,2),
    @Notes NVARCHAR(MAX) = NULL,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaimSettlements
    (
        InsuranceClaimID,
        TotalRequested,
        TotalApproved,
        CustomerPayable,
        InsurancePayable,
        SettlementDate,
        Notes,
        Status,
        CreatedDate,
        UpdatedDate,
        BranchID
    )
    VALUES
    (
        @InsuranceClaimID,
        @TotalRequested,
        @TotalApproved,
        @CustomerPayable,
        @InsurancePayable,
        GETDATE(),
        @Notes,
        'Pending',
        GETDATE(),
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewSettlementID;
END;

GO
