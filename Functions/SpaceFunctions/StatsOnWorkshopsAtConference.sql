
CREATE FUNCTION StatsOnWorkshopsAtConference(@ConferenceID INT)
RETURNS @res TABLE (
  ConfID INT,
  ConfName VARCHAR(120),
  Date DATE,
  WorkshopName VARCHAR(120),
  PercOccupWorkshop REAL
)
AS
BEGIN
  INSERT INTO @res
    SELECT c.ConfID, c.ConfName, doc.Date, w.Name, SUM(wso.NumberOfSeats) / w.SpaceLimit * 100
    FROM Conferences c JOIN DaysOfConf doc ON c.ConfID = doc.ConfID
    JOIN Workshops w ON doc.DayOfConfID = w.DayOfConfID
    JOIN WorkshopsSubOrders wso ON w.WorkshopID = wso.WorkshopID
    WHERE c.ConfID = @ConferenceID
    GROUP BY c.ConfID, c.ConfName, doc.Date, w.Name, w.SpaceLimit
  RETURN
END