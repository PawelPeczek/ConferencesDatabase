CREATE VIEW BasicClientsInfo
AS
SELECT c.ClientID, CONCAT(p.Name, ' ', p.Surname)'Contact Person', c.PhoneNumber, 'Individual client' [ClientName]
FROM Clients c JOIN IndividualsDetails id ON c.ClientID = id.ClientID
JOIN Participants p ON id.ParticipantID = p.ParticipantID
UNION
SELECT c.ClientID, CONCAT(cd.ContactPersonName, ' ', cd.ContactPersonSurname)'Contact Person', c.PhoneNumber, cd.CompanyName
FROM Clients c JOIN CompDetails cd ON c.ClientID = cd.ClientID
JOIN Orders o ON c.ClientID = o.ClientID