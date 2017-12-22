--------------------------------------------------------------
--            TRIGGERS ON WorkshopsSubOrders
--------------------------------------------------------------


DROP TRIGGER IsWorkshopAtConfDayCheck
-- is a Workshop at a conf day
CREATE TRIGGER IsWorkshopAtConfDayCheck
  ON WorkshopsSubOrders
  AFTER INSERT, UPDATE
  AS
  BEGIN

    DECLARE @numb_of_insrets AS INT = (
      SELECT COUNT(WorkshopID) FROM inserted
    )
    DECLARE @numb_of_matches AS INT = (
      SELECT COUNT(*)
      FROM inserted i JOIN OrdersOnConfDays oocd ON i.OrdOnConfDayID = oocd.OrdOnConfDayID
      JOIN DaysOfConf doc ON oocd.DayOfConfID = doc.DayOfConfID
      JOIN Workshops w ON doc.DayOfConfID = w.DayOfConfID AND i.WorkshopID = w.WorkshopID
    )

    IF @numb_of_insrets <> @numb_of_matches
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Trying to sign in on workshop which is not at the conference day connected with order!', 16, 3)
      END
  END

-- TRIGGER IsWorkshopAtConfDayCheck TESTS

INSERT INTO Workshops VALUES(2, 'Badania proktologiczne w praktyce', 'Jan', 'Nowak', 179.99, '12:00', '13:30', 15)
INSERT INTO Workshops VALUES(2, 'Grzebanie w dupie w praktyce', 'Jan', 'Nowak', 179.99, '12:30', '14:30', 15)
INSERT INTO Workshops VALUES(3, 'Badania proktologiczne w praktyce', 'Jan', 'Nowak', 179.99, '12:00', '13:30', 15)
INSERT INTO Workshops VALUES(3, 'Grzebanie w dupie w praktyce', 'Jan', 'Nowak', 179.99, '12:30', '14:30', 15)
SELECT * FROM Workshops
SELECT * FROM OrdersOnConfDays
INSERT INTO WorkshopsSubOrders VALUES(2, 15, 2), (2, 17, 2)
SELECT * FROM WorkshopsSubOrders
-- TESTS END
