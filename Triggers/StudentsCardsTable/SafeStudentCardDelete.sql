-- checking deleting without consequences (Student Card can be deleted if and
  -- only if isn't associated with any order at conference day)
CREATE TRIGGER SafeStudentCardDelete
  ON StudentCards
  AFTER DELETE
  AS
  BEGIN
    DECLARE @num_of_viol INT = (
      SELECT COUNT(*)
      FROM deleted d
        JOIN Participants p ON p.ParticipantID = d.ParticipantID
        JOIN ParticipAtConfDay pacd ON p.ParticipantID = pacd.ParticipantID
    )

    IF @num_of_viol <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Cannot delete Student Card because of association with order at conference day.', 16, 13)
      END
  END
