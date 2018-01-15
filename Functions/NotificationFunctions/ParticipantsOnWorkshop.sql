CREATE FUNCTION ParticipantsOnWorkshop(@WorkshopID INT)
RETURNS @res TABLE (
  ParticipantID INT,
  ParticipantName VARCHAR(32),
  ParticipantSurname VARCHAR(32),
  ClientID INT,
  Client VARCHAR (64)
)
AS
BEGIN
  INSERT INTO @res(ParticipantId, ParticipantName, ParticipantSurname, ClientID, Client)
    SELECT p.ParticipantID, p.Name, p.Surname, bci.ClientID, bci.ClientName
      FROM Participants p
      JOIN ParticipAtConfDay pacd ON p.ParticipantID = pacd.ParticipantID
      JOIN ParticipantsAtWorkshops paw ON pacd.EntryID = paw.EntryID
      JOIN WorkshopsSubOrders wso ON paw.WorkshopSubOrderID = wso.WorkshopSubOrderID
      JOIN Workshops w ON wso.WorkshopID = w.WorkshopID
      JOIN OrdersOnConfDays oocd ON pacd.OrdOnConfDayID = oocd.OrdOnConfDayID
      JOIN Orders o ON oocd.OrderID = o.OrderID
      JOIN BasicClientsInfo bci ON bci.ClientID = o.ClientID
      WHERE w.WorkshopID = 9364
  RETURN
END