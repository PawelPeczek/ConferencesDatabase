----------------------------------------------
--        Triggers ON PriceThresholds
----------------------------------------------
-- checking if we are not trying to insert a price threshold level
-- after the actual event
CREATE TRIGGER PriceThreshDateNotAfterConfDay
  ON PriceThresholds
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
        FROM inserted i JOIN DaysOfConf doc ON doc.DayOfConfID = i.DayOfConfID
        WHERE doc.Date < i.EndDate
      )

    IF @num_of_viol <> 0
      BEGIN
          ROLLBACK TRANSACTION
          RAISERROR('Threshold End Date cannot be after conference day date!', 16, 10)
      END
  END
