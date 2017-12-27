CREATE PROCEDURE ChangeNumbOfSeatsAtWorkshopSubOrd(
  @WorkshopSubOrderID INT,
  @NumberOfSeats SMALLINT
)
AS
BEGIN 
  UPDATE WorkshopsSubOrders SET NumberOfSeats = @NumberOfSeats WHERE WorkshopSubOrderID = @WorkshopSubOrderID
END