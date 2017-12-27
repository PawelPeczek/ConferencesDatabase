CREATE PROC CreateWorkshop
  (
    @DayOfConfID INT,
    @Name VARCHAR(120),
    @Value DECIMAL(8, 2),
    @StartTime TIME(0),
    @EndTime TIME(0),
    @SpaceLimit SMALLINT,
    @TeacherName VARCHAR(32) = NULL,
    @TeacherSurname VARCHAR(32) = NULL
  )
AS
BEGIN
  INSERT INTO Workshops VALUES(@DayOfConfID, @Name, @TeacherName, @TeacherSurname, @Value, @StartTime, @EndTime, @SpaceLimit)
END