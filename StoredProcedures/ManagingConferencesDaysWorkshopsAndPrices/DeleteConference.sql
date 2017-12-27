CREATE PROC DeleteConference (
  @ConfID INT
)
AS
BEGIN
  DELETE FROM Conferences WHERE ConfID = @ConfID
END
