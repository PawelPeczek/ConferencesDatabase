CREATE FUNCTION FreeSpaceAtConfDay (@ConfDayID INT)
RETURNS INT
AS
BEGIN
  RETURN(
    SELECT doc.SpaceLimit - SUM(oocd.NumberOfStudentSeats + oocd.NumberOfRegularSeats)
    FROM DaysOfConf doc JOIN OrdersOnConfDays oocd ON doc.DayOfConfID = oocd.DayOfConfID
    AND doc.DayOfConfID = @ConfDayID
    GROUP BY doc.DayOfConfID, doc.SpaceLimit
  )
END