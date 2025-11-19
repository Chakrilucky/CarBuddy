SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsurancePolicy_Get]
(
    @PolicyID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM InsurancePolicies
    WHERE PolicyID = @PolicyID;
END;

GO
