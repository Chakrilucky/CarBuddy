SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsuranceCompany_Get]
(
    @InsuranceCompanyID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM InsuranceCompanies
    WHERE InsuranceCompanyID = @InsuranceCompanyID;
END;

GO
