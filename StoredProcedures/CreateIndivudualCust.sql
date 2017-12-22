-- creating individual user
DROP PROCEDURE CreateIndivudualCust
CREATE PROCEDURE CreateIndivudualCust
  (
    @Login VARCHAR(45),
    @Password VARCHAR(64),
    @Email VARCHAR(80),
    @PhoneNumber VARCHAR(16),
    @PESEL VARCHAR(11),
    @Name VARCHAR(32),
    @Surname VARCHAR(32),
    @StudentCardNumber VARCHAR(16) = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
    INSERT INTO Clients VALUES (@Login, HASHBYTES('SHA2_512', @Password), @Email, @PhoneNumber);
    DECLARE @ClientID INT = SCOPE_IDENTITY()
    INSERT INTO Participants VALUES (@PESEL, @Name, @Surname)
    DECLARE @ParticipantID INT = SCOPE_IDENTITY()
    INSERT INTO IndividualsDetails VALUES(@ClientID, @ParticipantID)
    INSERT INTO ParticipRegByClients VALUES (@ClientID, @ParticipantID)
    IF @StudentCardNumber IS NOT NULL AND @FromDate IS NOT NULL AND @ToDate IS NOT NULL
      BEGIN
        INSERT INTO StudentCards VALUES (@ParticipantID, @StudentCardNumber, @FromDate, @ToDate)
      END
    COMMIT
  END TRY
  BEGIN CATCH
      IF @@TRANCOUNT > 0
        ROLLBACK
      DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
      SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
  END CATCH
END