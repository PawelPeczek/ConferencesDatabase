CREATE VIEW MissingParticipationsView
AS
SELECT o.OrderId, SUM(isnull(pacd.ParticipantID, 0)) [Sum]
FROM ORDERS o
JOIN OrdersOnConfDays oocd ON o.OrderId=oocd.OrderId
JOIN DaysOfConf doc ON oocd.DayOfConfId=doc.DayOfConfId AND doc.Date >= GETDATE() AND DATEDIFF(DAY,GETDATE(),doc.Date) <= 14
LEFT JOIN ParticipAtConfDay pacd ON oocd.OrdOnConfDayID = pacd.OrdOnConfDayID
GROUP BY o.OrderId, oocd.NumberOfRegularSeats, oocd.NumberOfStudentSeats
HAVING SUM(isnull(pacd.ParticipantID, 0)) < (oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats)