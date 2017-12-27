-- Associating new student card to participant
DROP PROCEDURE AssociateStudentCard
CREATE PROCEDURE AssociateStudentCard
  (
    @ParticipantID INT,
    @StudentCardNumber VARCHAR(16),
    @FromDate DATE,
    @ToDate DATE
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      INSERT INTO StudentCards VALUES (@ParticipantID, @StudentCardNumber, @FromDate, @ToDate)
      COMMIT
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
    DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
    SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
    RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
  END CATCH
END