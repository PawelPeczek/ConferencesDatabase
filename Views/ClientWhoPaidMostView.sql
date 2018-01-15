DROP VIEW ClientWhoPaidMostView
CREATE VIEW ClientWhoPaidMostView
AS
SELECT c.ClientID, CONCAT(p.Name, ' ', p.Surname)'Contact Person', c.PhoneNumber, SUM(t.Total) [Total] FROM Clients c JOIN IndividualsDetails id ON c.ClientID = id.ClientID
JOIN Participants p ON id.ParticipantID = p.ParticipantID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN GetValueOfAllOrders() t ON t.OrderId = o.OrderID
GROUP BY c.ClientID, CONCAT(p.Name, ' ', p.Surname), c.PhoneNumber
UNION
SELECT c.ClientID, CONCAT(cd.ContactPersonName, ' ', cd.ContactPersonSurname)'Contact Person', c.PhoneNumber,
        SUM(t.Total) [Total] FROM Clients c JOIN CompDetails cd ON c.ClientID = cd.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN GetValueOfAllOrders() t ON t.OrderId = o.OrderID
GROUP BY c.ClientID, cd.ContactPersonName, cd.ContactPersonSurname, c.PhoneNumber