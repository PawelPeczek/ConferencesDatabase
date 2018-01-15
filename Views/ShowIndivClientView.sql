CREATE VIEW ShowIndivClientView
AS
SELECT c.ClientID,CONCAT(p.Name,' ',p.Surname) AS 'Client',
	c.Email,c.PhoneNumber, c.Login, c.Password	
FROM Clients c
JOIN IndividualsDetails id ON c.ClientID = id.ClientID
JOIN Participants p ON p.ParticipantID = id.ParticipantID