DROP TYPE BATCH_ORD_ON_CONF_DAY
CREATE TYPE BATCH_ORD_ON_CONF_DAY AS TABLE (
  InternalID INT IDENTITY(1, 1) PRIMARY KEY,
  DayOfConfID INT NOT NULL,
  NumberOfRegularSeats SMALLINT NOT NULL,
  NumberOfStudentSeats SMALLINT NOT NULL DEFAULT 0
)

DROP PROCEDURE CreateOrderBatch
CREATE PROC CreateOrderBatch
  (
    @ClientID INT,
    @DateOfBook DATE,
    @data BATCH_ORD_ON_CONF_DAY READONLY
  )
AS
BEGIN
  DECLARE @IDs AS TABLE (
    OrderID INT,
    InternalID INT IDENTITY (1,1)
  )
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO Orders
    OUTPUT inserted.OrderID INTO @IDs(OrderID)
    VALUES(@ClientID, @DateOfBook, DEFAULT )

    INSERT INTO OrdersOnConfDays SELECT d.DayOfConfID, i.OrderID, d.NumberOfRegularSeats, d.NumberOfStudentSeats
                                 FROM @IDS i JOIN @data d ON d.InternalID = i.InternalID
    COMMIT
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK
    DECLARE @ErrorMessage2 nvarchar(4000),  @ErrorSeverity2 int;
    SELECT @ErrorMessage2 = ERROR_MESSAGE(),@ErrorSeverity2 = ERROR_SEVERITY();
    RAISERROR(@ErrorMessage2, @ErrorSeverity2, 1);
  END CATCH
END