-- creating individual user
-- important!
-- Procedure handles withs istuation when 
-- a participant want to register as
-- individual client
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
      DECLARE @ParticipantIDFound INT = (
        SELECT p.ParticipantID
        FROM Participants p JOIN ParticipantsDetails pd ON p.ParticipantID = pd.ParticipantID
        WHERE pd.Email = @Email AND (p.PESEL IS NULL OR @PESEL IS NULL OR @PESEL = p.PESEL)
        AND p.Name = @Name AND p.Surname = @Surname
      )
      IF @ParticipantIDFound IS NOT NULL
      BEGIN
        BEGIN TRY
          BEGIN TRANSACTION
            DELETE FROM ParticipantsDetails WHERE ParticipantID = @ParticipantIDFound
            INSERT INTO Clients VALUES (@Login, HASHBYTES('SHA2_512', @Password), @Email, @PhoneNumber);
            DECLARE @ClientIDRetry INT = SCOPE_IDENTITY()
            INSERT INTO IndividualsDetails VALUES(@ClientIDRetry, @ParticipantIDFound)
            INSERT INTO ParticipRegByClients VALUES (@ClientIDRetry, @ParticipantIDFound)
          COMMIT
        END TRY
        BEGIN CATCH
          IF @@TRANCOUNT > 0
            ROLLBACK
          DECLARE @ErrorMessage1 nvarchar(4000),  @ErrorSeverity1 int;
          SELECT @ErrorMessage1 = ERROR_MESSAGE(),@ErrorSeverity1 = ERROR_SEVERITY();
          RAISERROR(@ErrorMessage1, @ErrorSeverity1, 1);
        END CATCH
      END
      ELSE
      BEGIN
        DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
        SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
      END
  END CATCH
END
