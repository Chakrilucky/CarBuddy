SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceClaim_Get]
(
    @InsuranceClaimID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM InsuranceClaims
    WHERE InsuranceClaimID = @InsuranceClaimID;
END;

GO
