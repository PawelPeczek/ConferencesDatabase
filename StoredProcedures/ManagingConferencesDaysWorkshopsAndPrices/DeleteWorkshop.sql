CREATE PROC DeleteWorkshop
  (
    @WorkshopID INT
  )
AS
BEGIN
  DELETE FROM Workshops WHERE WorkshopID = @WorkshopID
END