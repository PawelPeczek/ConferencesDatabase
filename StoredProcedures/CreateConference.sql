CREATE PROCEDURE CreateConference
  (
      @ConfName VARCHAR(120),
      @ConfTopic VARCHAR(256) = NULL,
      @ConfDescription VARCHAR(512) = NULL,
      @StudentDiscount REAL = 0
  )
AS BEGIN
  INSERT INTO Conferences VALUES (@ConfName, @ConfTopic, @ConfDescription, @StudentDiscount)
END
