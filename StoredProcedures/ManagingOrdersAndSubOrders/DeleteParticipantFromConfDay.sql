CREATE PROCEDURE DeleteParticipantFromConfDay (
  @EntryID INT
)
AS
BEGIN
  DELETE FROM ParticipantsAtWorkshops
  WHERE EntryID = @EntryID

  DELETE FROM ParticipAtConfDay
  WHERE EntryID = @EntryID
END