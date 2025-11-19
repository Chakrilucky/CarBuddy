SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_Add]
(
    @InsuranceClaimID      INT,
    @ItemType              VARCHAR(50),
    @ItemName              NVARCHAR(200),
    @ItemDescription       NVARCHAR(MAX),
    @Quantity              DECIMAL(10,2),
    @RequestedUnitPrice    DECIMAL(10,2),
    @IsApproved            BIT = 0,
    @ApprovedUnitPrice     DECIMAL(10,2) = NULL,
    @SurveyorRemarks       NVARCHAR(MAX),
    @BranchID              INT,
    @CreatedBy             INT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO InsuranceClaimEstimateItems 
    (
        InsuranceClaimID,
        ItemType,
        ItemName,
        ItemDescription,
        Quantity,
        RequestedUnitPrice,
        IsApproved,
        ApprovedUnitPrice,
        SurveyorRemarks,
        CreatedDate,
        BranchID
        -- ❌ RequestedTotalPrice → computed
        -- ❌ ApprovedTotalPrice → computed
    )
    VALUES
    (
        @InsuranceClaimID,
        @ItemType,
        @ItemName,
        @ItemDescription,
        @Quantity,
        @RequestedUnitPrice,
        @IsApproved,
        @ApprovedUnitPrice,
        @SurveyorRemarks,
        GETDATE(),
        @BranchID
    );

    SELECT SCOPE_IDENTITY() AS NewEstimateItemID;
END;

GO
