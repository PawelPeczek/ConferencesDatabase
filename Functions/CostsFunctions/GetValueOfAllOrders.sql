CREATE FUNCTION GetValueOfAllOrders()
RETURNS @res TABLE(
  OrderID INT,
  Total DECIMAL(10, 2)
)
AS
BEGIN
  INSERT INTO @res
    SELECT o.OrderID,
    SUM(oocd.NumberOfStudentSeats * (1 - c.StudentDiscount) * pt.Value + oocd.NumberOfRegularSeats * pt.Value)
    + SUM(ISNULL(t3.Sum, 0)) [Total]
    FROM Orders o JOIN OrdersOnConfDays oocd ON o.OrderID = oocd.OrderID
    JOIN DaysOfConf doc ON oocd.DayOfConfID = doc.DayOfConfID
    JOIN
    (
      SELECT pt1.DayOfConfID, pt1.Value, pt1.EndDate FROM PriceThresholds pt1
    ) pt ON doc.DayOfConfID = pt.DayOfConfID
    AND pt.EndDate = (
        SELECT MIN(pt2.EndDate) FROM PriceThresholds pt2 WHERE pt2.EndDate >= o.DateOfBook
        AND pt2.DayOfConfID = doc.DayOfConfID
        GROUP BY pt2.DayOfConfID
    )
    JOIN Conferences c ON doc.ConfID = c.ConfID
    LEFT JOIN
      (
        SELECT oocd1.OrdOnConfDayID, SUM(w.Value * wso.NumberOfSeats) [Sum]
        FROM Workshops w JOIN WorkshopsSubOrders wso ON w.WorkshopID = wso.WorkshopID
        JOIN OrdersOnConfDays oocd1 ON wso.OrdOnConfDayID = oocd1.OrdOnConfDayID
        GROUP BY oocd1.OrdOnConfDayID
      ) t3
    ON t3.OrdOnConfDayID = oocd.OrdOnConfDayID
  GROUP BY o.OrderID
  RETURN
END