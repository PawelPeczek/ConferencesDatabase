-- checking if while updating - reduce of space required match with already
-- assigned participants
CREATE TRIGGER ReduceSeatsCheck
  ON OrdersOnConfDays
  AFTER UPDATE
  AS
  BEGIN
    DECLARE @numb_of_stud_viol INT = (
      SELECT COUNT(i.OrdOnConfDayID)
      FROM inserted i JOIN DaysOfConf doc ON i.DayOfConfID = doc.DayOfConfID
      JOIN ParticipAtConfDay pacd ON i.OrdOnConfDayID = pacd.OrdOnConfDayID
      JOIN Participants p ON pacd.ParticipantID = p.ParticipantID
      LEFT JOIN StudentCards sc ON p.ParticipantID = sc.ParticipantID
      WHERE sc.StudentCardID IS NOT NULL AND doc.Date BETWEEN sc.FromDate AND sc.ToDate
      GROUP BY i.OrdOnConfDayID, i.NumberOfStudentSeats
      HAVING i.NumberOfStudentSeats > COUNT(pacd.ParticipantID)
    )

    DECLARE @numb_of_reg_viol INT = (
      SELECT COUNT(i.OrdOnConfDayID)
      FROM inserted i JOIN DaysOfConf doc ON i.DayOfConfID = doc.DayOfConfID
      JOIN ParticipAtConfDay pacd ON i.OrdOnConfDayID = pacd.OrdOnConfDayID
      JOIN Participants p ON pacd.ParticipantID = p.ParticipantID
      LEFT JOIN StudentCards sc ON p.ParticipantID = sc.ParticipantID
      WHERE sc.StudentCardID IS NULL OR
            (sc.StudentCardID IS NOT NULL  AND doc.Date NOT BETWEEN sc.FromDate AND sc.ToDate)
      GROUP BY i.OrdOnConfDayID, i.NumberOfRegularSeats
      HAVING i.NumberOfRegularSeats > COUNT(pacd.ParticipantID)
    )

    IF @numb_of_reg_viol > 0 OR @numb_of_stud_viol > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot reduce the ammount of space required in order over the number of participants already assigned!', 16, 19)
      END
  END