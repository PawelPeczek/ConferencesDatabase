---------------------------------------------------------
--          TRIGGERS On Workshops
---------------------------------------------------------
-- forbidding reducing space limit below demanded number of seats
CREATE TRIGGER ReducingWorkshopSpaceBelowRequiredNumberForbidden
  ON Workshops
  AFTER UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*) FROM (
      SELECT i.SpaceLimit - SUM(wso.NumberOfSeats) [sum]
      FROM inserted i JOIN WorkshopsSubOrders wso ON wso.WorkshopID = i.WorkshopID
      GROUP BY i.DayOfConfID, i.SpaceLimit
      ) t
      WHERE t.sum < 0
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot reduce Space Limit at Workshop below the number reserved by clients.', 16, 13)
      END
  END
