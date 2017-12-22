-- deleting participant
DROP PROCEDURE DeleteParticipantByClient
CREATE PROCEDURE DeleteParticipantByClient (
  @ClientID INT,
  @ParticipantID INT
)
AS
BEGIN
  SET NOCOUNT OFF -- to preserve @@ROWCOUNT
  -- foreign key konstraints should not allow to delete
  -- a participant who is a client and who is assigned to any order
  DELETE FROM ParticipRegByClients WHERE ClientID = @ClientID AND ParticipantID = @ParticipantID
  IF @@ROWCOUNT <> 0
  BEGIN
    BEGIN TRY
      BEGIN TRANSACTION
      DELETE FROM StudentCards WHERE ParticipantID = @ParticipantID -- release FK_StudentCards_ParticipantID at first
      DELETE FROM Participants WHERE ParticipantID = @ParticipantID
      DELETE FROM ParticipantsDetails WHERE ParticipantID = @ParticipantID
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
  ELSE
    RAISERROR('Trying to delete participant not assigned to a client!', 16, 1)
END
