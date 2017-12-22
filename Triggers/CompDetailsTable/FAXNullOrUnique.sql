  -- FAX NULL OR UNIQUE
CREATE TRIGGER FAXNullOrUnique
  ON CompDetails
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM
        (
          SELECT FAX
          FROM CompDetails
          WHERE FAX IS NOT NULL
          GROUP BY FAX
          HAVING COUNT(ClientID) > 1
        ) t
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('FAX must be unique if is present in Company information.', 16, 15)
      END

  END
