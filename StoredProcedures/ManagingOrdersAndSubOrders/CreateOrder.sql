CREATE PROCEDURE CreateOrder (
  @ClientID INT,
  @DateOfBook DATE,
  @DayOfConfID INT,
  @NumberOfRegularSeats SMALLINT,
  @NumberOfStudentSeats SMALLINT = 0
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      INSERT INTO Orders VALUES (@ClientID, @DateOfBook , DEFAULT)
      INSERT INTO OrdersOnConfDays VALUES(@DayOfConfID, SCOPE_IDENTITY(), @NumberOfRegularSeats, @NumberOfStudentSeats)
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