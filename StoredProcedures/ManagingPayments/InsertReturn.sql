CREATE PROCEDURE InsertReturn (
  @OrderID INT,
  @Date DATE,
  @Value DECIMAL(8, 2),
  @AccountNumber VARCHAR(28),
  @TitleOfPayment VARCHAR(140)
) AS
BEGIN
  INSERT INTO Returns VALUES (@OrderID, @Date, @Value, @AccountNumber, @TitleOfPayment)
END