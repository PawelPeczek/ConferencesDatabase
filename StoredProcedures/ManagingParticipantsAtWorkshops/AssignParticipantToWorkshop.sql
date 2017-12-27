CREATE PROCEDURE AssignParticipantToWorkshop(
  @EntryID INT,
  @WorkshopSubOrderID INT
)
AS
BEGIN
  INSERT INTO ParticipantsAtWorkshops VALUES (@EntryID, @WorkshopSubOrderID)
END