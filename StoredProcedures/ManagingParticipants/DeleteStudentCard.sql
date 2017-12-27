-- deleting student card from participant
DROP PROCEDURE DeleteStudentCard
CREATE PROCEDURE DeleteStudentCard
  (
    @StudentCardID INT
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      DELETE FROM StudentCards WHERE StudentCardID = @StudentCardID
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