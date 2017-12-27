DROP TRIGGER WorkshopReduceCheck
CREATE TRIGGER WorkshopReduceCheck
  ON WorkshopsSubOrders
  AFTER UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(i.WorkshopSubOrderID)
      FROM inserted i JOIN OrdersOnConfDays oocd ON i.OrdOnConfDayID = oocd.OrdOnConfDayID
      JOIN ParticipantsAtWorkshops paw ON i.WorkshopSubOrderID = paw.WorkshopSubOrderID
      GROUP BY i.WorkshopSubOrderID, oocd.NumberOfRegularSeats, oocd.NumberOfStudentSeats
      HAVING COUNT(paw.EntryID) > oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK
        RAISERROR('Reducing number of seats in workshop suborder over the assigned number of participants at workshop is forbidden!', 16, 19)
      END

  END