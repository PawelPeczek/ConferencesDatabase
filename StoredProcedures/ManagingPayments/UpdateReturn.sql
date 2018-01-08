CREATE PROCEDURE UpdateReturn (
  @ReturnID INT,
  @Date DATE,
  @Value DECIMAL(8, 2),
  @AccountNumber VARCHAR(28),
  @TitleOfPayment VARCHAR(140)
) AS
BEGIN
  UPDATE Returns SET Date = @Date, Value = @Value, AccountNumber = @AccountNumber, TitleOfPayment = @TitleOfPayment
  WHERE ReturnID = @ReturnID
END