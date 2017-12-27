CREATE PROCEDURE ChangeParticipantData(
  @ParticipantID INT,
  @Email VARCHAR(80),
  @PESEL VARCHAR(11),
  @Name VARCHAR(32),
  @Surname VARCHAR(32)
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      IF NOT EXISTS(SELECT * FROM ParticipantsDetails WHERE ParticipantID = @ParticipantID)
        RAISERROR('Unsupported operation', 16, 1)
      UPDATE Participants SET PESEL = @PESEL, Name = @Name, Surname = @Surname WHERE ParticipantID = @ParticipantID
      UPDATE ParticipantsDetails SET Email = @Email WHERE ParticipantID = @ParticipantID
    COMMIT
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK
    DECLARE @ErrorMessage2 nvarchar(4000),  @ErrorSeverity2 int;
    SELECT @ErrorMessage2 = ERROR_MESSAGE(),@ErrorSeverity2 = ERROR_SEVERITY();
    RAISERROR(@ErrorMessage2, @ErrorSeverity2, 1);
  END CATCH
END
