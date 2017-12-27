CREATE FUNCTION StatsOnConferences()
RETURNS @res TABLE (
  ConfID INT,
  ConfName VARCHAR(120),
  Date DATE,
  PercOccupConf REAL
)
AS
BEGIN
  INSERT INTO @res
    SELECT c.ConfID, c.ConfName, doc.Date,
      SUM(oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats) / doc.SpaceLimit * 100 [PercOccupConf]
    FROM Conferences c JOIN DaysOfConf doc ON c.ConfID = doc.ConfID
    JOIN OrdersOnConfDays oocd ON doc.DayOfConfID = oocd.DayOfConfID
    GROUP BY c.ConfID, c.ConfName, doc.Date, doc.SpaceLimit
  RETURN
END