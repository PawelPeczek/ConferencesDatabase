CREATE PROCEDURE EditWorkshop
  (
    @WorkshopID INT,
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
  UPDATE Workshops SET Name = @Name, Value = @Value, StartTime = @StartTime,
    EndTime = @EndTime, SpaceLimit = @SpaceLimit, TeacherName = @TeacherName, TeacherSurname = @TeacherSurname
    WHERE WorkshopID = @WorkshopID
END