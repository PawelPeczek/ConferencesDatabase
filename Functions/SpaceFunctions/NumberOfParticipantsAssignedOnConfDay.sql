CREATE FUNCTION NumberOfParticipantsAssignedOnConfDay(@ConfDayID INT)
RETURNS INT
AS
BEGIN
  RETURN (
    SELECT COUNT(*)
    FROM ParticipAtConfDay pacd JOIN OrdersOnConfDays oocd
      ON pacd.OrdOnConfDayID = oocd.OrdOnConfDayID
    WHERE oocd.DayOfConfID = @ConfDayID
  )
END