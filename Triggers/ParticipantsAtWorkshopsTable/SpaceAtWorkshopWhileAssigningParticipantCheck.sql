DROP TRIGGER SpaceAtWorkshopWhileAssigningParticipantCheck
  CREATE TRIGGER SpaceAtWorkshopWhileAssigningParticipantCheck
    ON ParticipantsAtWorkshops
    AFTER INSERT, UPDATE
    AS
    BEGIN
      DECLARE @num_of_vio AS INT = (
      SELECT COUNT(*) FROM (
        SELECT t1.WorkshopSubOrderID
        FROM
          WorkshopsSubOrders t1
          JOIN (SELECT DISTINCT WorkshopSubOrderID
                FROM inserted) t2
            ON t1.WorkshopSubOrderID = t2.WorkshopSubOrderID
          JOIN ParticipantsAtWorkshops paw ON t1.WorkshopSubOrderID = paw.WorkshopSubOrderID
        GROUP BY t1.WorkshopSubOrderID, t1.NumberOfSeats
        HAVING COUNT(paw.EntryID) <> t1.NumberOfSeats
      ) t
    )

    IF @num_of_vio > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Trying to assign more participants than possible to one workshop!', 16, 8)
      END
    END


  -- TRIGGER SpaceAtWorkshopWhileAssigningParticipantCheck TESTS
    SELECT * FROM WorkshopsSubOrders
    SELECT * FROM ParticipantsAtWorkshops
    DELETE FROM ParticipantsAtWorkshops
  -- TESTS END
