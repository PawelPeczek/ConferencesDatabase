CREATE FUNCTION NumOfParticipAssignOnConfDayByOrderID(@OrderID INT, @DayOfConfID INT)
RETURNS INT
AS
BEGIN
    RETURN (
    SELECT COUNT(*)
    FROM ParticipAtConfDay pacd JOIN OrdersOnConfDays oocd
      ON pacd.OrdOnConfDayID = oocd.OrdOnConfDayID
    WHERE oocd.DayOfConfID = @DayOfConfID AND oocd.OrderID = @OrderID
  )
END