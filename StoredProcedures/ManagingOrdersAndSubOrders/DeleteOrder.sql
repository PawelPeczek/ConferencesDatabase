CREATE PROCEDURE DeleteOrder(
  @OrderID INT
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
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
    UPDATE Orders SET Status = 1 WHERE OrderID = @OrderID
    COMMIT
  END TRY
  BEGIN CATCH
     IF @@TRANCOUNT > 0
        ROLLBACK
      DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
      SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
  END CATCH
END