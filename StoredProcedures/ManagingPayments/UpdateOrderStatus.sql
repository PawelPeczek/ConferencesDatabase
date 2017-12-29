CREATE PROCEDURE UpdateOrderStatus
AS
BEGIN
  UPDATE Orders SET Status = 1 WHERE OrderID IN (
    SELECT o.OrderID
    FROM Orders o JOIN GetValueOfAllOrders() t ON o.OrderID = t.OrderID
    JOIN Payments p ON o.OrderID = p.OrderID
    WHERE DATEDIFF(WEEK, o.DateOfBook , GETDATE()) >= 1
    GROUP BY o.OrderID, t.Total
    HAVING SUM(p.Value) < t.Total
  )
  EXECUTE UpdateSysInfo
END