CREATE PROCEDURE DeleteParticipantFromConfDay (
  @EntryID INT
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
        DELETE FROM ParticipantsAtWorkshops
        WHERE EntryID = @EntryID
        DELETE FROM ParticipAtConfDay
        WHERE EntryID = @EntryID
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