CREATE PROCEDURE AssignParticipantAtConfDay(
  @OrdOnConfDayID INT,
  @ParticipantID INT
)
AS
BEGIN
  INSERT INTO ParticipAtConfDay VALUES (@ParticipantID, @OrdOnConfDayID)
END