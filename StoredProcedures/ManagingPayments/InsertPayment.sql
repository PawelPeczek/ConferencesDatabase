DROP PROCEDURE InsertPayment
CREATE PROC InsertPayment(
  @OrderID INT,
  @Value DECIMAL(8,2),
  @AccountNumber  VARCHAR(28),
  @TitleOfPayment VARCHAR(140),
  @TransferSender VARCHAR(70),
  @Date DATE = NULL
)
AS
BEGIN
  IF @Date IS NOT NULL
    INSERT INTO Payments VALUES (@OrderID, @Date, @Value, @AccountNumber, @TitleOfPayment, @TransferSender)
  ELSE
      INSERT INTO Payments VALUES (@OrderID, DEFAULT , @Value, @AccountNumber, @TitleOfPayment, @TransferSender)
END