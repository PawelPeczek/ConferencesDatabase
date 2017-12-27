CREATE PROCEDURE ChangeStatusOfOrder(
  @OrderID INT,
  @Status BIT
)
AS
BEGIN
  UPDATE Orders SET Status = @Status WHERE OrderID = @OrderID
END