CREATE VIEW CancelledReservationView
AS
SELECT o.OrderID, c.[Contact Person] AS 'Contact Person',
	c.PhoneNumber, o.DateOfBook, o.Status
FROM Orders o
JOIN (SELECT * FROM BasicClientsInfo) c ON o.ClientID = c.ClientID
WHERE o.Status = 1