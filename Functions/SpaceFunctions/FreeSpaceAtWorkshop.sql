
CREATE FUNCTION FreeSpaceAtWorkshop (@WorkshopID INT)
RETURNS INT
AS
BEGIN
  RETURN (
    SELECT w.SpaceLimit - SUM(wso.NumberOfSeats)
    FROM Workshops w JOIN WorkshopsSubOrders wso ON w.WorkshopID = wso.WorkshopID
    AND w.WorkshopID = @WorkshopID
    GROUP BY w.WorkshopID, w.SpaceLimit
  )
END