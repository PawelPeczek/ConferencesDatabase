CREATE PROCEDURE DeleteWorkshopSubOrder(
  @WorkshopSubOrderID INT
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      DELETE FROM ParticipantsAtWorkshops
      WHERE WorkshopSubOrderID = @WorkshopSubOrderID
      DELETE FROM WorkshopsSubOrders
      WHERE WorkshopSubOrderID = @WorkshopSubOrderID
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