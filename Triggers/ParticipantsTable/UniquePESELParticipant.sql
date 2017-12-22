-------------------------------------------------
--        TRIGGERS ON Participants
-------------------------------------------------


CREATE TRIGGER UniquePESELParticipant
  ON Participants
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_dist_PESEL AS int = (SELECT COUNT(DISTINCT PESEL) FROM Participants WHERE PESEL IS NOT NULL);
    DECLARE @num_of_all_PESEL AS int = (SELECT COUNT(PESEL) FROM Participants WHERE PESEL IS NOT NULL);
    IF @num_of_dist_PESEL != @num_of_all_PESEL
    BEGIN
      ROLLBACK TRANSACTION
      RAISERROR('Unique PESEL constraint violation!', 16, 1)
    END
  END

-- TRIGGER UniquePESELParticipant TESTS:

INSERT INTO Participants VALUES (94043000952, 'Jan', 'Kowalski')
INSERT INTO Participants VALUES (NULL, 'Jan', 'Kowalski')
INSERT INTO Participants VALUES (94043000952, 'Marian', 'Kowalski')
INSERT INTO Participants VALUES
  (94043000932, 'Jan', 'Kowalski'),
  (NULL, 'Jan', 'Kowalski'),
  (94043000932, 'Jan', 'Kowalski')
SELECT * FROM Participants

-- END OF TESTS
