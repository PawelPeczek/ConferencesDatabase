-- Checking if the conference day is in the future not in the past
CREATE TRIGGER IsDayOfConfInTheFuture
  ON OrdersOnConfDays
  AFTER INSERT, UPDATE
  AS
  BEGIN

    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM inserted i
        JOIN DaysOfConf doc ON doc.DayOfConfID = i.DayOfConfID
        JOIN Orders o ON i.OrderID = o.OrderID
      WHERE o.DateOfBook > doc.Date
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot make an Order for past reservation!', 16, 14)
      END

  END
