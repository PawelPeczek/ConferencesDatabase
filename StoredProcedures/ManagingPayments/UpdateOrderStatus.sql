CREATE PROCEDURE UpdateOrderStatus
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      UPDATE Orders SET Status = 1 WHERE OrderID IN (
        SELECT o.OrderID
        FROM Orders o JOIN GetValueOfAllOrders() t ON o.OrderID = t.OrderID
        LEFT JOIN Payments p ON o.OrderID = p.OrderID
        WHERE DATEDIFF(WEEK, o.DateOfBook , GETDATE()) >= 1
        GROUP BY o.OrderID, t.Total
        HAVING SUM(p.Value) < t.Total OR (SUM(p.Value) IS NULL AND t.Total <> 0)
      )
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