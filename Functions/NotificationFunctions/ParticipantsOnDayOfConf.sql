CREATE FUNCTION ParticipantsOnDayOfConf(@DayOfConfID INT)
RETURNS @res TABLE (
  ParticipantName VARCHAR(32),
  ParticipantSurname VARCHAR(32)
)
AS
BEGIN
    INSERT INTO @res(ParticipantName,ParticipantSurname)
    SELECT p.Name,p.Surname
    FROM ParticipAtConfDay pacd JOIN OrdersOnConfDays oocd
      ON pacd.OrdOnConfDayID = oocd.OrdOnConfDayID
	  JOIN Participants p  ON p.ParticipantID = pacd.ParticipantID
    WHERE oocd.DayOfConfID = @DayOfConfID
  RETURN
END