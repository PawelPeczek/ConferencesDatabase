--------------------------------------------------------------
--            TRIGGERS ON ParticipAtConfDay
--------------------------------------------------------------
DROP TRIGGER ConfParticipantsCheck
CREATE TRIGGER ConfParticipantsCheck
  ON ParticipAtConfDay
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @TMP TABLE(
      OrdOnConfDayID INT,
      ParticipantID INT,
      Date DATE,
      FromDate DATE,
      ToDate DATE
    );

    INSERT INTO @TMP
      SELECT pacd.OrdOnConfDayID, pacd.ParticipantID, doc.Date, sc.FromDate, sc.ToDate
      FROM ParticipAtConfDay pacd
      JOIN (SELECT DISTINCT OrdOnConfDayID FROM inserted) i ON i.OrdOnConfDayID = pacd.OrdOnConfDayID
      JOIN Participants p ON pacd.ParticipantID = p.ParticipantID
      JOIN OrdersOnConfDays oocd ON i.OrdOnConfDayID = oocd.OrdOnConfDayID
      JOIN DaysOfConf doc ON oocd.DayOfConfID = doc.DayOfConfID
      LEFT JOIN StudentCards sc ON p.ParticipantID = sc.ParticipantID AND doc.Date BETWEEN sc.FromDate AND sc.ToDate

    DECLARE @num_of_viol_A AS INT = (
      SELECT COUNT(t1.OrdOnConfDayID) FROM
        OrdersOnConfDays t1 JOIN
        (SELECT tmp.OrdOnConfDayID, COUNT(tmp.ParticipantID) [NumbOfStudentSeats]
         FROM @TMP tmp
          WHERE tmp.FromDate IS NOT NULL
          GROUP BY tmp.OrdOnConfDayID
        ) t2
        ON t1.OrdOnConfDayID = t2.OrdOnConfDayID
        WHERE (t1.NumberOfStudentSeats - t2.NumbOfStudentSeats) < 0
    )

    DECLARE @num_of_viol_B AS INT = (
      SELECT COUNT(t1.OrdOnConfDayID) FROM
        OrdersOnConfDays t1 JOIN
        (SELECT tmp.OrdOnConfDayID, COUNT(DISTINCT tmp.ParticipantID) [NumberOfRegSeats]
         FROM @TMP tmp
          WHERE tmp.FromDate IS NULL
          GROUP BY tmp.OrdOnConfDayID
        ) t2
        ON t1.OrdOnConfDayID = t2.OrdOnConfDayID
        WHERE (t1.NumberOfRegularSeats - t2.NumberOfRegSeats) < 0
    )

    IF @num_of_viol_A > 0 OR @num_of_viol_B > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Trying to assign more participants than requested seats!', 16, 6)
      END
  END


  -- TRIGGER ConfParticipantsCheck TESTS
SELECT * FROM OrdersOnConfDays

SELECT * FROM Participants
INSERT INTO Participants VALUES (94043000953, 'Marian', 'Kowalski')
INSERT INTO StudentCards VALUES (1, '291518', '01/01/2018', '06/30/2018')
INSERT INTO StudentCards VALUES (7, '291518', '01/01/2017', '06/30/2017')
SELECT * FROM StudentCards
SELECT * FROM DaysOfConf
UPDATE DaysOfConf SET SpaceLimit = 60
UPDATE OrdersOnConfDays SET NumberOfRegularSeats = 2 WHERE OrdOnConfDayID = 23
SELECT * FROM OrdersOnConfDays
INSERT INTO ParticipAtConfDay VALUES (7, 23), (2, 23);

SELECT * FROM ParticipAtConfDay
DELETE FROM ParticipAtConfDay
-- TESTS END
