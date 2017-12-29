-------------------------------------------------------
--                Triggers on Clients
-------------------------------------------------------
CREATE TRIGGER GloballyUniqueEmailOnClients
  ON Clients
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM inserted i
      WHERE i.Email IN (SELECT Email FROM ParticipantsDetails)
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
          RAISERROR('Trying to assign the same e-mail to the other person!', 16, 11)
      END
  END