----------------------------------------------
--        Triggers ON Workshops
----------------------------------------------
-- checking if workshop max number of seats does not exceed maximum conf day capacity with taking into
-- account the possibility of workshops clashes
DROP TRIGGER WorkshopsDaysOfConfCapacityCheck
CREATE TRIGGER WorkshopsDaysOfConfCapacityCheck
  ON Workshops
  AFTER INSERT, UPDATE
  AS
  BEGIN

    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM
        (
          SELECT DISTINCT doc.DayOfConfID, doc.SpaceLimit
          FROM inserted i
            JOIN DaysOfConf doc ON doc.DayOfConfID = i.DayOfConfID
        ) t1
        JOIN
        (
          SELECT i.DayOfConfID, SUM(w.SpaceLimit) [sum]
          FROM inserted i CROSS JOIN Workshops w
          WHERE i.DayOfConfID = w.DayOfConfID AND
                (((i.StartTime >= w.StartTime AND i.StartTime <= w.EndTime) OR
                (w.StartTime >= i.StartTime AND  w.StartTime <= i.EndTime)) AND
                NOT (i.StartTime = w.EndTime OR w.StartTime = i.EndTime))
          GROUP BY i.DayOfConfID
        ) t2
          ON t1.DayOfConfID = t2.DayOfConfID
      WHERE t1.SpaceLimit < t2.sum
    )

    PRINT(@num_of_viol)
    IF @num_of_viol <> 0
      BEGIN
          ROLLBACK TRANSACTION
          RAISERROR('Number of seats at workshop cannot exceed number of seats at conference day!', 16, 10)
      END
  END
