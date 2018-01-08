CREATE TRIGGER CheckReturns
ON Returns
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM inserted i
      WHERE (
            SELECT SUM(r.Value) FROM Returns r
            WHERE r.OrderID = i.OrderID
            GROUP BY r.OrderID
          ) >  isnull((
            SELECT SUM(p.Value) FROM Payments p
            WHERE p.OrderID = i.OrderID
            GROUP BY p.OrderID
        ), 0)
    )

  IF @num_of_viol > 0
  BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('Trying to return more money than was paid in the order!', 16, 16)
  END

END