-------------------------------------------------
--        TRIGGERS ON OrdersOnConfDays
-------------------------------------------------


DROP TRIGGER ConferenceSeatsCheck
CREATE TRIGGER ConferenceSeatsCheck
  ON OrdersOnConfDays
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_vio AS INT = (
      SELECT COUNT(i.DayOfConfID)
      FROM (
              SELECT DayOfConfID, SUM(NumberOfStudentSeats + NumberOfRegularSeats) [num_Seats]
              FROM OrdersOnConfDays
              GROUP BY DayOfConfID
           ) t1 JOIN inserted i ON i.DayOfConfID = t1.DayOfConfID
          JOIN
          (
              SELECT DayOfConfID, SpaceLimit [num_Seats]
              FROM DaysOfConf
          ) t2 ON i.DayOfConfID = t2.DayOfConfID
          WHERE t2.num_Seats - t1.num_Seats < 0
    )
    IF @num_of_vio > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Requested number of seats at conference day exceed available space!', 16, 2)
      END
  END
  -- TRIGGER ConferenceSeatsCheck TESTS:
  INSERT INTO Conferences(ConfName, ConfTopic, ConfDescription, StudentDiscount) VALUES ('Konferencja proktologów', 'Badania odbytów', 'Jak najlepiej wejść kumuś w dupę', 0.3)
  SELECT * FROM Conferences
  INSERT INTO DaysOfConf VALUES (1, '05/25/2018', 30)
  INSERT INTO DaysOfConf VALUES (1, '05/26/2018', 30)
  SELECT * FROM DaysOfConf
  INSERT INTO PriceThresholds(EndDate, Value, DayOfConfID) VALUES('04/30/2018', 199.99,2)
  INSERT INTO PriceThresholds(EndDate, Value, DayOfConfID) VALUES('05/25/2018', 249.99,2)
  INSERT INTO PriceThresholds(EndDate, Value, DayOfConfID) VALUES('04/30/2018', 199.99,3)
  INSERT INTO PriceThresholds(EndDate, Value, DayOfConfID) VALUES('05/26/2018', 249.99,3)
  SELECT * FROM PriceThresholds
  INSERT INTO Clients VALUES ('JAN123', 'zaq1@WSX', 'jan@1a.pl', 999999999)
  INSERT INTO Clients VALUES ('JAN1234', 'zaq1@WSX', 'jan1@1a.pl', 899999999)
  SELECT * FROM Clients
  INSERT INTO Orders VALUES (4, '04/30/2018', DEFAULT)
  INSERT INTO Orders VALUES (6, '04/30/2018', DEFAULT)
  SELECT * FROM Orders
  INSERT INTO OrdersOnConfDays VALUES(2, 9, 3, 6)
  INSERT INTO OrdersOnConfDays VALUES(3, 9, 13, 6)
  INSERT INTO OrdersOnConfDays VALUES(2, 10, 21, 0)
  INSERT INTO OrdersOnConfDays VALUES(3, 10, 0, 2)
  DELETE FROM OrdersOnConfDays
  SELECT * FROM OrdersOnConfDays
    INSERT INTO OrdersOnConfDays VALUES(2, 9, 3, 6),
                                       (3, 9, 13, 6),
                                       (2, 10, 21, 1),
                                       (3, 10, 0, 2)
  SELECT * FROM OrdersOnConfDays
    INSERT INTO OrdersOnConfDays VALUES(2, 9, 3, 6),
                                       (3, 9, 13, 6),
                                       (2, 10, 21, 0),
                                       (3, 10, 0, 2)
  -- END OF TESTS
