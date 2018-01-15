CREATE VIEW BestClientView
AS
SELECT c.ClientID,CONCAT(p.Name,' ',p.Surname) AS 'Client',
	c.Email,c.PhoneNumber, t.AmountOfReservation
FROM Clients c
JOIN IndividualsDetails id ON c.ClientID = id.ClientID
JOIN Participants p ON p.ParticipantID = id.ParticipantID
JOIN (SELECT o.ClientID, SUM(oocd.NumberOfRegularSeats+oocd.NumberOfStudentSeats) AS 'AmountOfReservation' 
	FROM OrdersOnConfDays oocd JOIN Orders o ON o.OrderID = oocd.OrderID AND o.Status=0 GROUP BY o.ClientID) AS t
ON t.ClientID = c.ClientID
UNION
SELECT c.ClientID, cd.CompanyName AS 'Client',
	c.Email,c.PhoneNumber, t.AmountOfReservation
FROM Clients c
JOIN CompDetails cd ON c.ClientID = cd.ClientID
JOIN (SELECT o.ClientID, SUM(oocd.NumberOfRegularSeats+oocd.NumberOfStudentSeats) AS 'AmountOfReservation' 
	FROM OrdersOnConfDays oocd JOIN Orders o ON o.OrderID = oocd.OrderID AND o.Status=0 GROUP BY o.ClientID) AS t
ON t.ClientID = c.ClientID