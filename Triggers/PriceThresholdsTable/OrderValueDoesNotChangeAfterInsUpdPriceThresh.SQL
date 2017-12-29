DROP TRIGGER OrderValueDoesNotChangeAfterInsUpdPriceThresh
CREATE TRIGGER OrderValueDoesNotChangeAfterInsUpdPriceThresh
  ON PriceThresholds
  AFTER INSERT, UPDATE
  AS
  BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1
      BEGIN
          ROLLBACK TRANSACTION
          RAISERROR('Only one price threshold can be inserted/updated simultaneously!', 16, 11)
      END
    -- if any Order is caught by new price threshold
    -- AND the value is different from the old one
    -- then error (if the same - it's ok and can be
    -- used to make special discount by company -
    -- ex. temporary sale in the middle of some price threshold)
    DECLARE @insertedID INT = (SELECT ThresholdID FROM inserted)
    DECLARE @insertedDOCID INT = (SELECT DayOfConfID FROM inserted)
    DECLARE @num_of_viol INT =
    (
      SELECT COUNT(*)
    FROM (
      SELECT o.OrderID, i.Value
      FROM inserted i
        JOIN DaysOfConf doc ON i.DayOfConfID = doc.DayOfConfID
        JOIN OrdersOnConfDays oocd ON doc.DayOfConfID = oocd.DayOfConfID
        JOIN Orders o ON oocd.OrderID = o.OrderID
      WHERE o.DateOfBook BETWEEN
      (SELECT MAX(pt.EndDate) FROM PriceThresholds pt WHERE pt.EndDate < i.EndDate)
      AND i.EndDate
    ) t1 JOIN (
      SELECT o.OrderID, t.Value
      FROM (
        SELECT * FROM PriceThresholds WHERE DayOfConfID = @insertedDOCID AND ThresholdID <> @insertedID
      ) t
      JOIN DaysOfConf doc ON t.DayOfConfID = doc.DayOfConfID
      JOIN OrdersOnConfDays oocd ON doc.DayOfConfID = oocd.DayOfConfID
      JOIN Orders o ON oocd.OrderID = o.OrderID
      WHERE o.DateOfBook BETWEEN
      (SELECT MAX(pt.EndDate) FROM PriceThresholds pt WHERE pt.EndDate < t.EndDate)
      AND t.EndDate
    ) t2 ON t1.OrderID = t2.OrderID
    WHERE t1.Value <> t2.Value
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot change the value of order by changing price threshold after accepting order!', 16, 17)
      END

  END