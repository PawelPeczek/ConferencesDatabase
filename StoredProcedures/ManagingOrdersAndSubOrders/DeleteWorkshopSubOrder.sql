CREATE PROCEDURE DeleteWorkshopSubOrder(
  @WorkshopSubOrderID INT
)
AS
BEGIN
  DELETE FROM ParticipantsAtWorkshops
  WHERE WorkshopSubOrderID = @WorkshopSubOrderID

  DELETE FROM WorkshopsSubOrders
  WHERE WorkshopSubOrderID = @WorkshopSubOrderID
END