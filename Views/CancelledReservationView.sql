CREATE VIEW CancelledReservationView
AS
SELECT o.OrderID, CONCAT(cd.ContactPersonName , ' ' , cd.ContactPersonSurname) AS 'Contact Person',
	c.PhoneNumber, o.DateOfBook, o.Status
FROM Orders o 
JOIN Clients c ON o.ClientID = c.ClientID
JOIN CompDetails cd ON cd.ClientID =c.ClientID
WHERE o.Status = 1 
UNION 
SELECT o.OrderID, CONCAT(p.Name , ' ' , p.Surname) AS 'Contact Person',
	c.PhoneNumber, o.DateOfBook, o.Status
FROM Orders o 
JOIN Clients c ON o.ClientID = c.ClientID
JOIN IndividualsDetails id ON id.ClientID =c.ClientID
JOIN Participants p ON p.ParticipantID = id.ParticipantID
JOIN ParticipantsDetails pd ON pd.ParticipantID = p.ParticipantID
WHERE o.Status = 1 
