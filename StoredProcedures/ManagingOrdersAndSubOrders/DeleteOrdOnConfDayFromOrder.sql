CREATE PROCEDURE DeleteOrdOnConfDayFromOrder (
  @OrdOnConfDayID INT
)
AS
BEGIN
  DELETE FROM ParticipantsAtWorkshops WHERE
  (EntryID IN (SELECT EntryID FROM ParticipAtConfDay WHERE OrdOnConfDayID = @OrdOnConfDayID))

  DELETE FROM WorkshopsSubOrders WHERE OrdOnConfDayID = @OrdOnConfDayID

  DELETE FROM ParticipAtConfDay WHERE OrdOnConfDayID = @OrdOnConfDayID

  DELETE FROM OrdersOnConfDays WHERE OrdOnConfDayID = @OrdOnConfDayID
END