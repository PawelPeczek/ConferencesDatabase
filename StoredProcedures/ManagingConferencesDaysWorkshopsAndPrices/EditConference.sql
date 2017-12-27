CREATE PROCEDURE EditConference
  (
      @ConfID INT,
      @ConfName VARCHAR(120),
      @ConfTopic VARCHAR(256) = NULL,
      @ConfDescription VARCHAR(512) = NULL,
      @StudentDiscount REAL = 0
  )
AS BEGIN
  UPDATE Conferences SET ConfName = @ConfName, ConfTopic = @ConfTopic, ConfDescription = @ConfDescription,
  StudentDiscount = @StudentDiscount WHERE ConfID = @ConfID
END
