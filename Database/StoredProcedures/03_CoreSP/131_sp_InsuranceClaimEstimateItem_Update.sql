SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_Update]
(
    @ClaimEstimateItemID   INT,
    @ItemType              VARCHAR(50),
    @ItemName              NVARCHAR(200),
    @ItemDescription       NVARCHAR(MAX),
    @Quantity              DECIMAL(10,2),
    @RequestedUnitPrice    DECIMAL(10,2),
    @IsApproved            BIT,
    @ApprovedUnitPrice     DECIMAL(10,2),
    @SurveyorRemarks       NVARCHAR(MAX),
    @BranchID              INT,
    @UpdatedBy             INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE InsuranceClaimEstimateItems
    SET
        ItemType            = @ItemType,
        ItemName            = @ItemName,
        ItemDescription     = @ItemDescription,
        Quantity            = @Quantity,
        RequestedUnitPrice  = @RequestedUnitPrice,
        IsApproved          = @IsApproved,
        ApprovedUnitPrice   = @ApprovedUnitPrice,
        SurveyorRemarks     = @SurveyorRemarks,
        UpdatedDate         = GETDATE()
        -- ❌ RequestedTotalPrice → computed
        -- ❌ ApprovedTotalPrice → computed
    WHERE 
        ClaimEstimateItemID = @ClaimEstimateItemID
        AND BranchID = @BranchID;
END;

GO
