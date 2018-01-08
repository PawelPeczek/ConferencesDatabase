CREATE PROCEDURE DeleteReturn (
  @ReturnID INT
) AS
BEGIN
  DELETE FROM Returns WHERE ReturnID = @ReturnID
END