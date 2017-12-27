CREATE PROCEDURE DeleteOrder(
  @OrderID INT
)
AS
BEGIN

  DELETE FROM ParticipantsAtWorkshops
  WHERE EntryID IN
  (SELECT EntryID FROM ParticipAtConfDay WHERE OrdOnConfDayID IN
  (SELECT OrdOnConfDayID FROM OrdersOnConfDays WHERE OrderID = @OrderID))

  DELETE FROM ParticipAtConfDay WHERE OrdOnConfDayID IN
  (SELECT OrdOnConfDayID FROM OrdersOnConfDays WHERE OrderID = @OrderID)

  DELETE FROM WorkshopsSubOrders WHERE
  OrdOnConfDayID IN
  (SELECT OrdOnConfDayID FROM OrdersOnConfDays WHERE OrderID = @OrderID)

  DELETE FROM OrdersOnConfDays WHERE OrderID = @OrderID

END