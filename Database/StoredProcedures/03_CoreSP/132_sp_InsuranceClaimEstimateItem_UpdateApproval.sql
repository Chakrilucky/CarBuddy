SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_InsuranceClaimEstimateItem_UpdateApproval]
(
    @ClaimEstimateItemID INT,
    @IsApproved BIT,
    @ApprovedUnitPrice DECIMAL(10,2) = NULL,
    @SurveyorRemarks NVARCHAR(500) = NULL,
    @UpdatedBy INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate item exists under same branch
    IF NOT EXISTS (
        SELECT 1 FROM InsuranceClaimEstimateItems
        WHERE ClaimEstimateItemID = @ClaimEstimateItemID
          AND BranchID = @BranchID
    )
    BEGIN
        RAISERROR('Item not found or access denied.', 16, 1);
        RETURN;
    END;

    -- Update without touching computed column
    UPDATE InsuranceClaimEstimateItems
    SET 
        IsApproved = @IsApproved,
        ApprovedUnitPrice = 
            CASE 
                WHEN @IsApproved = 1 THEN @ApprovedUnitPrice 
                ELSE 0 
            END,
        SurveyorRemarks = @SurveyorRemarks,
        UpdatedDate = GETDATE()
    WHERE 
        ClaimEstimateItemID = @ClaimEstimateItemID
        AND BranchID = @BranchID;
END;

GO
