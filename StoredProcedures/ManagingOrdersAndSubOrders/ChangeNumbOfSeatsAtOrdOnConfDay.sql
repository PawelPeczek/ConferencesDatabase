CREATE PROCEDURE ChangeNumbOfSeatsAtOrdOnConfDay(
  @OrdOnConfDay INT,
  @NumberOfRegSeats SMALLINT,
  @NumberOfStudentsSeats SMALLINT = 0
)
AS
BEGIN
  UPDATE OrdersOnConfDays SET NumberOfRegularSeats = @NumberOfRegSeats,
    NumberOfStudentSeats = @NumberOfStudentsSeats
  WHERE OrdOnConfDayID = @OrdOnConfDay
END