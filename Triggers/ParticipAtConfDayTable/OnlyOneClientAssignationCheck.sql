-- Participant may be assigned to a conference day only by one client
DROP TRIGGER OnlyOneClientAssignationCheck
CREATE TRIGGER OnlyOneClientAssignationCheck
  ON ParticipAtConfDay
  AFTER INSERT, UPDATE
  AS
  BEGIN

    IF (SELECT COUNT (DISTINCT OrdOnConfDayID) FROM inserted) <> 1
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('It is not allowed to add participants at conferences day in batches with different orders associated!', 16, 16)
      END

    DECLARE @num_of_viol INT = (
      SELECT COUNT(t.no_part)
      FROM (
        SELECT COUNT(pacd.ParticipantID) [no_part]
          FROM DaysOfConf doc JOIN OrdersOnConfDays oocd ON doc.DayOfConfID = oocd.DayOfConfID
          JOIN ParticipAtConfDay pacd ON oocd.OrdOnConfDayID = pacd.OrdOnConfDayID
          WHERE doc.DayOfConfID = ( -- one distinct OrdOnConfDayID in inserted ensures that only ONE
            SELECT doci.DayOfConfID
              FROM inserted i JOIN OrdersOnConfDays oocdi ON oocdi.OrdOnConfDayID = i.OrdOnConfDayID
              JOIN DaysOfConf doci ON oocdi.DayOfConfID = doci.DayOfConfID
          ) AND pacd.ParticipantID IN (SELECT ParticipantID FROM inserted)
        HAVING COUNT(pacd.ParticipantID) > 1
      ) t)

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Participant has already been assigned to a conference day (in another Order)!', 16, 17)
      END
  END