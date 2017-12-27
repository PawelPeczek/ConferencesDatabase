CREATE TYPE WORKSHOP_SUBORDER_BATCH AS TABLE(
  WorkshopID INT,
  NumberOfSeats SMALLINT
)
CREATE PROCEDURE InsertWorkshopSubOrderBatch(
  @OrderOnConfDayID INT,
  @data WORKSHOP_SUBORDER_BATCH READONLY
)
AS
BEGIN
  INSERT INTO WorkshopsSubOrders SELECT @OrderOnConfDayID, WorkshopID, NumberOfSeats FROM @data
END