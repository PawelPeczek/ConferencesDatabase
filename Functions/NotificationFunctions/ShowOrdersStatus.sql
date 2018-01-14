CREATE FUNCTION ShowOrdersStatus()
RETURNS @res TABLE (
  OrderID INT,
  ClientID INT,
  Name VARCHAR(128),
  DateOfBook DATE,
  Status BIT
)
AS
BEGIN
  INSERT @res
         SELECT OrderID, c.ClientID, CONCAT(p.Name, ' ', p.Surname) [Name], DateOfBook, Status FROM Orders
         JOIN Clients c ON Orders.ClientID = c.ClientID
         JOIN IndividualsDetails id ON c.ClientID = id.ClientID
         JOIN Participants p ON id.ParticipantID = p.ParticipantID
         UNION
         SELECT OrderID, c.ClientID, cd.CompanyName [Name], DateOfBook, Status FROM Orders
         JOIN Clients c ON Orders.ClientID = c.ClientID
         JOIN CompDetails cd ON c.ClientID = cd.ClientID
  RETURN
END 