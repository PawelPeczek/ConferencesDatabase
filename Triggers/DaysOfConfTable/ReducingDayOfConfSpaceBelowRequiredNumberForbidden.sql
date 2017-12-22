---------------------------------------------------------
--          TRIGGERS On DaysOfConf
---------------------------------------------------------
-- forbidding reducing space limit below demanded number of seats
CREATE TRIGGER ReducingDayOfConfSpaceBelowRequiredNumberForbidden
  ON DaysOfConf
  AFTER UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*) FROM (
      SELECT i.SpaceLimit - SUM(oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats) [sum]
      FROM inserted i JOIN OrdersOnConfDays oocd ON oocd.DayOfConfID = i.DayOfConfID
      GROUP BY i.DayOfConfID, i.SpaceLimit
      ) t
      WHERE t.sum < 0
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot reduce Space Limit at Conference day below the number reserved by clients.', 16, 13)
      END

  END
