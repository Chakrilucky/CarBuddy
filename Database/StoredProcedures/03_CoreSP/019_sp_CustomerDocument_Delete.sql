SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CustomerDocument_Delete]
(
    @DocumentID INT,
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM DocumentUploads
    WHERE DocumentID = @DocumentID
      AND BranchID = @BranchID;

END;

GO
