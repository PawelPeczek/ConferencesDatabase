-- Cannot change the value of accepted order by changing the
-- value of a workshop
CREATE TRIGGER OrderValueDoesNotChangeByUpdateWorkshop
  ON Workshops
  AFTER UPDATE
  AS
  BEGIN
    IF (SELECT COUNT(*) FROM inserted) <> 1
      BEGIN
        ROLLBACK
         RAISERROR('Only one Workshop can be updated simultaneously!', 16, 11)
      END
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM inserted i JOIN WorkshopsSubOrders wso ON i.WorkshopID = wso.WorkshopID
      WHERE (SELECT Value FROM deleted) <> i.Value
    )

    IF @num_of_viol <> 0
      BEGIN
          ROLLBACK TRANSACTION
          RAISERROR('Cannot modify accepted orders values by changing the value of workshop!', 16, 18)
      END

  END