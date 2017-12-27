CREATE PROC EditPriceThreshold (
    @PriceThresholdID INT,
    @EndDate DATETIME,
    @Value DECIMAL(8, 2)
)
AS
BEGIN
  UPDATE PriceThresholds SET EndDate = @EndDate, Value = @Value WHERE ThresholdID = @PriceThresholdID
END