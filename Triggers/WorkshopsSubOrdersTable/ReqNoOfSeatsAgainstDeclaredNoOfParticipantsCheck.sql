DROP TRIGGER ReqNoOfSeatsAgainstDeclaredNoOfParticipantsCheck
-- checking if req_numb_of seats at workshop <= booked number of seats at conf day
-- checking also the situation when there is a clash between Workshops and overall amount of
-- previously declared seats is enough to cover each clashes workshops (even if one by one this number is OK)
CREATE TRIGGER ReqNoOfSeatsAgainstDeclaredNoOfParticipantsCheck
  ON WorkshopsSubOrders
  AFTER INSERT, UPDATE
  AS
  BEGIN


    DECLARE @WorkshopEssentials TABLE(
      WorkshopID INT,
      StartTime TIME,
      EndTime TIME
    );

    -- Highly used TMP table
    DECLARE @TMP TABLE(
      OrdOnConfDayID INT,
      NumberOfRegularSeats INT,
      NumberOfStudentSeats INT,
      WorkshopID INT,
      NumberOfSeats INT
    );

    -- IN TMP we have each OrdOnConfDayID connected with inserted and ALL workshop suborders
    -- affected by OrdOnConfDay (including these which are not in inserted to be able to see
    -- potential troubles globally).
    INSERT INTO @TMP
      SELECT DISTINCT oocd.OrdOnConfDayID, oocd.NumberOfRegularSeats, oocd.NumberOfStudentSeats,
                  wso.WorkshopID, wso.NumberOfSeats
      FROM
        inserted i JOIN OrdersOnConfDays oocd ON i.OrdOnConfDayID = oocd.OrdOnConfDayID
        JOIN WorkshopsSubOrders wso ON oocd.OrdOnConfDayID = wso.OrdOnConfDayID

    if (SELECT COUNT(DISTINCT OrdOnConfDayID) FROM @TMP) <> 1
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Only one distinct OrderOnConfDayID in batch allowed!!', 16, 4)
      END
    -- SAVING only essentials INFO from Workshops
    INSERT INTO @WorkshopEssentials
      SELECT w.WorkshopID, w.StartTime, w.EndTime FROM
      @TMP t
      JOIN Workshops w ON t.WorkshopID = w.WorkshopID;

      DECLARE @numb_of_vio INT = (
        SELECT COUNT(*)
          FROM
          (SELECT t1.fst, SUM(t2.NumberOfSeats) [sum]
          FROM
            (
              -- This part will produce association of workshops which are connected with OrderOnConfDay
              -- with the other ones which may clash (we want also non-clashing workshops so <= in condition)
              SELECT
                w1.WorkshopID [fst],
                w2.WorkshopID [snd]
              FROM @WorkshopEssentials w1 CROSS JOIN @WorkshopEssentials w2
              -- <= to have also self connections
              WHERE (w1.WorkshopID < w2.WorkshopID AND
                    ((w1.StartTime > w2.StartTime AND w1.StartTime < w2.EndTime) OR
                     (w2.StartTime > w1.StartTime AND w2.StartTime < w1.EndTime)))
                    OR w1.WorkshopID = w2.WorkshopID
            ) t1
            JOIN @tmp t2 ON t2.WorkshopID = t1.snd
          GROUP BY t1.fst) top1
          JOIN @tmp top2 ON top2.WorkshopID = top1.fst
          WHERE [sum] > (top2.NumberOfRegularSeats + top2.NumberOfStudentSeats)
          -- if some workshop and all its clashing workshops have more seats requested than previosly reserved ->
          -- should be error
      )

--     SIMPLE VERSION
--     DECLARE @numb_of_vio INT = (
--       SELECT COUNT(t1.OrdOnConfDayID)
--       FROM inserted i JOIN OrdersOnConfDays t1 ON t1.OrdOnConfDayID = i.OrdOnConfDayID
--       WHERE t1.NumberOfStudentSeats + t1.NumberOfRegularSeats - i.NumberOfSeats < 0
--     )

    IF @numb_of_vio > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Requested number of seats at workshop is greater than requested number of seats at conference day!!', 16, 4)
      END
  END

--  TRIGGER ReqNoOfSeatsAgainstDeclaredNoOfParticipantsCheck TESTS

SELECT * FROM Workshops
INSERT INTO Workshops VALUES(2, 'Catchy one #1', 'Jan', 'Nowak', 179.99, '19:00', '20:30', 10)
INSERT INTO Workshops VALUES(2, 'Catchy one #2', 'Jan', 'Nowak', 179.99, '19:15', '20:45', 10)
INSERT INTO Workshops VALUES(2, 'Catchy one #3', 'Jan', 'Nowak', 179.99, '20:45', '21:50', 10)
INSERT INTO Workshops VALUES(3, 'Catchy one #4', 'Jan', 'Nowak', 179.99, '8:30', '9:30', 10)
INSERT INTO Workshops VALUES(3, 'Catchy one #5', 'Jan', 'Nowak', 179.99, '9:00', '10:30', 10)
SELECT * FROM Clients
INSERT INTO Clients VALUES ('JAN12345', 'zaq1@WSX', 'jan@12a.pl', 999999939)
INSERT INTO Clients VALUES ('JAN123456', 'zaq1@WSX', 'jan1@11a.pl', 899993999)
INSERT INTO Orders VALUES (7, '05/01/2018', DEFAULT )
INSERT INTO Orders VALUES (8, '05/01/2018', DEFAULT )
SELECT * FROM Orders
SELECT * FROM DaysOfConf
UPDATE DaysOfConf SET SpaceLimit = 60
SELECT * FROM DaysOfConf
INSERT INTO OrdersOnConfDays VALUES (2, 11, 7, 0)
INSERT INTO OrdersOnConfDays VALUES (3, 11, 7, 0)
INSERT INTO OrdersOnConfDays VALUES (2, 12, 7, 0)
INSERT INTO OrdersOnConfDays VALUES (3, 12, 7, 0)
SELECT * FROM OrdersOnConfDays
DELETE FROM WorkshopsSubOrders
INSERT INTO WorkshopsSubOrders VALUES
  (7, 20, 5),
  (5, 20, 5),
  (8, 20, 5)
INSERT INTO WorkshopsSubOrders VALUES
  (7, 20, 5)

SELECT * FROM WorkshopsSubOrders
-- END TESTS
