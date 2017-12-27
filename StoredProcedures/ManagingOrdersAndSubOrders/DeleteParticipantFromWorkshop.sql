CREATE PROCEDURE DeleteParticipantFromWorkshop(
  @EntryID INT,
  @WorkshopSubOrderID INT
)
AS
BEGIN
  DELETE FROM ParticipantsAtWorkshops WHERE EntryID = @EntryID AND WorkshopSubOrderID = @WorkshopSubOrderID
END