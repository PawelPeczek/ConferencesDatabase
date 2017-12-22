--------------------------------------------------------------
--            TRIGGERS ON ParticipantsAtWorkshops
--------------------------------------------------------------

CREATE TRIGGER IfOrderIncludesWorkshopCheck
  ON ParticipantsAtWorkshops
  AFTER INSERT, UPDATE
  AS
  BEGIN

    DECLARE @num_of_vio AS INT = (
      SELECT COUNT(t1.EntryID)
      FROM inserted t1
        JOIN ParticipAtConfDay t2 ON
        t1.EntryID = t2.EntryID
        JOIN OrdersOnConfDays t3 ON
        t2.OrdOnConfDayID = t3.OrdOnConfDayID
        JOIN WorkshopsSubOrders t4 ON
        t1.WorkshopSubOrderID = t4.WorkshopSubOrderID
        JOIN OrdersOnConfDays t5 ON
        t4.OrdOnConfDayID = t5.OrdOnConfDayID
      WHERE (t3.OrdOnConfDayID - t5.OrdOnConfDayID) <> 0
    )

    IF @num_of_vio > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Trying to assign participant(s) to a workshop(s) while they are not included in order!', 16, 7)
      END

  END

  -- TRIGGER IfOrderIncludesWorkshopCheck TESTS

  SELECT * FROM WorkshopsSubOrders
  DELETE FROM ParticipAtConfDay
  INSERT INTO ParticipAtConfDay VALUES (7, 23), (2, 20);
  SELECT * FROM ParticipAtConfDay
  INSERT INTO ParticipantsAtWorkshops VALUES(47, 92)

  -- TESTS END
