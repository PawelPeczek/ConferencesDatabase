CREATE TYPE PAYMENT_BATCH AS TABLE(
  OrderID        INT           NOT NULL,
  Date           DATE          NOT NULL DEFAULT GETDATE(),
  Value          DECIMAL(8, 2) NOT NULL,
  AccountNumber  VARCHAR(28)   NOT NULL, -- IBAN i NRB
  TitleOfPayment VARCHAR(140)  NOT NULL,
  TransferSender VARCHAR(70)   NOT NULL
)

CREATE PROC BatchInsertPayments(
  @data PAYMENT_BATCH READONLY
)
AS
BEGIN
  INSERT INTO Payments SELECT OrderID, Date, Value, AccountNumber, TitleOfPayment, TransferSender FROM @data
END
