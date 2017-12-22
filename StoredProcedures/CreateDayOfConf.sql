CREATE PROCEDURE CreateDayOfConf
  (
    @ConfID INT,
    @Date DATE,
    @SpaceLimit SMALLINT,
    @EndDate DATETIME,
    @Value DECIMAL(8, 2)
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO DaysOfConf VALUES (@ConfID, @Date, @SpaceLimit)
    INSERT INTO PriceThresholds VALUES (@ConfID, @EndDate, @Value)
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
