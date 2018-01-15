CREATE FUNCTION ParticipantsOnWorkshop(@WorkshopID INT)
RETURNS @res TABLE (
  ParticipantName VARCHAR(32),
  ParticipantSurname VARCHAR(32)
)
AS
BEGIN
    INSERT INTO @res(ParticipantName,ParticipantSurname)
    SELECT p.Name,p.Surname
    FROM Participants p 
	JOIN ParticipAtConfDay pacd ON pacd.ParticipantID = p.ParticipantID
	JOIN ParticipantsAtWorkshops paw ON paw.EntryID = pacd.EntryID
	JOIN WorkshopsSubOrders wso On wso.WorkshopSubOrderID=paw.WorkshopSubOrderID
    WHERE wso.WorkshopID = @WorkshopID
  RETURN
END
