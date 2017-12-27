CREATE PROCEDURE InsertWorkshopSubOrder(
  @OrderOnConfDayID INT,
  @WorkshopID INT,
  @NumberOfSeats SMALLINT
)
AS
BEGIN
  INSERT INTO WorkshopsSubOrders VALUES (@OrderOnConfDayID, @WorkshopID, @NumberOfSeats)
END