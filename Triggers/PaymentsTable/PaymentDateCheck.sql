---------------------------------------------------------
--          TRIGGERS On Payments
---------------------------------------------------------
CREATE TRIGGER PaymentDateCheck
ON Payments
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @num_of_valid INT = (
      SELECT COUNT(*)
    FROM inserted i JOIN Orders o ON o.OrderID = i.OrderID AND i.Date >= o.DateOfBook
    JOIN OrdersOnConfDays oocd ON o.OrderID = oocd.OrderID
    JOIN DaysOfConf doc ON oocd.DayOfConfID = doc.DayOfConfID AND i.Date <= doc.Date
  )
  IF @num_of_valid <> (SELECT COUNT (*) FROM inserted)
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Payment cannot be add with a date earlier than order date and further than date of conference day.', 16, 14)
    END
END