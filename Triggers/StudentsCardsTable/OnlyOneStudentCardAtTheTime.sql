---------------------------------------------------------
  --          TRIGGERS On StudentsCards
  ---------------------------------------------------------
  -- only one Student card at the time
DROP TRIGGER OnlyOneStudentCardAtTheTime
CREATE TRIGGER OnlyOneStudentCardAtTheTime
  ON StudentCards
  AFTER INSERT, UPDATE
  AS
  BEGIN

    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM (
        SELECT i.ParticipantID
        FROM inserted i CROSS JOIN StudentCards sc
        WHERE i.ParticipantID = sc.ParticipantID AND
              ((i.FromDate >= sc.FromDate AND i.FromDate <= sc.ToDate) OR
              (sc.FromDate >= i.FromDate AND  sc.FromDate <= i.ToDate))
        GROUP BY i.ParticipantID
        HAVING COUNT(sc.ParticipantID) > 1
      ) t)
    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('One participant is allowed to have only one Student card at the simultaneously registered.', 16, 12)
      END

  END
