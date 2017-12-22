-- no one participant can be assigned to more than one workshop at the same time
  DROP TRIGGER NoWorkshopAtTheSameTimeRuleCheck
  CREATE TRIGGER NoWorkshopAtTheSameTimeRuleCheck
    ON ParticipantsAtWorkshops
    AFTER INSERT, UPDATE
    AS
    BEGIN
      DECLARE @TMP TABLE(
        ParticipantID INT,
        WorkshopID INT,
        StartTime TIME(0),
        EndTime TIME(0)
      )

      INSERT INTO @TMP SELECT pacd1.ParticipantID, w.WorkshopID, w.StartTime, w.EndTime
        FROM
          (SELECT pacd.EntryID, pacd.ParticipantID
             FROM ParticipAtConfDay pacd JOIN inserted i ON pacd.EntryID = i.EntryID) pacd1
          JOIN ParticipantsAtWorkshops paw ON pacd1.EntryID = paw.EntryID
          JOIN WorkshopsSubOrders wso ON paw.WorkshopSubOrderID = wso.WorkshopSubOrderID
          JOIN Workshops w ON wso.WorkshopID = w.WorkshopID

      DECLARE @no_of_viol INT = (
        SELECT COUNT(*)
        FROM @TMP t1
          CROSS JOIN @TMP t2
        WHERE t1.WorkshopID < t2.WorkshopID AND
--               ((t1.StartTime > t2.StartTime AND t1.StartTime < t2.EndTime) OR
--                (t2.StartTime > t1.StartTime AND t2.StartTime < t1.EndTime))
              (((t1.StartTime >= t2.StartTime AND t1.StartTime <= t2.EndTime) OR
                (t2.StartTime >= t1.StartTime AND  t2.StartTime <= t1.EndTime)) AND
                NOT (t1.StartTime = t2.EndTime OR t2.StartTime = t1.EndTime))
      )

      IF @no_of_viol <> 0
        BEGIN
          ROLLBACK TRANSACTION
          RAISERROR('User can be assigned only to one workshop at the time!', 16, 9)
        END
    END
