CREATE PROCEDURE DeleteOrdOnConfDayFromOrder (
  @OrdOnConfDayID INT
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      DELETE FROM ParticipantsAtWorkshops WHERE
      (EntryID IN (SELECT EntryID FROM ParticipAtConfDay WHERE OrdOnConfDayID = @OrdOnConfDayID))
      DELETE FROM WorkshopsSubOrders WHERE OrdOnConfDayID = @OrdOnConfDayID
      DELETE FROM ParticipAtConfDay WHERE OrdOnConfDayID = @OrdOnConfDayID
      DELETE FROM OrdersOnConfDays WHERE OrdOnConfDayID = @OrdOnConfDayID
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