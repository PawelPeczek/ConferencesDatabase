CREATE PROC CreatePriceThreshold
  (
    @ConfDayID INT,
    @EndDate DATETIME,
    @Value DECIMAL(8, 2)
  )
AS
BEGIN
  INSERT INTO PriceThresholds VALUES(@ConfDayID, @EndDate, @Value)
END