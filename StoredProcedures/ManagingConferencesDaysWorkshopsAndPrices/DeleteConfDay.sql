CREATE PROC DeleteConfDay (
  @DayOfConfID INT
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
    DELETE FROM PriceThresholds WHERE DayOfConfID = @DayOfConfID
    DELETE FROM DaysOfConf WHERE DayOfConfID = @DayOfConfID
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
