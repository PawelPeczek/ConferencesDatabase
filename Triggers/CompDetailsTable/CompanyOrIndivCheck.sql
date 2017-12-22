---------------------------------------------------------
--          TRIGGERS On CompDetails
---------------------------------------------------------
CREATE TRIGGER CompanyOrIndivCheck
  ON CompDetails
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*) FROM inserted i JOIN IndividualsDetails id
        ON i.ClientID = id.ClientID
    )
    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('A client can be either Individual or Company - not both at the same time.', 16, 14)
      END
  END
