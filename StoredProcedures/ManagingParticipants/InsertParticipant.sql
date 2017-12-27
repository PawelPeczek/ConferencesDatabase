-- Creating/inserting Participants by
DROP PROCEDURE InsertParticipant
CREATE PROCEDURE InsertParticipant (
  @ClientID INT,
  @Email VARCHAR(80),
  @PESEL VARCHAR(11),
  @Name VARCHAR(32),
  @Surname VARCHAR(32)
)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      INSERT INTO Participants VALUES (@PESEL, @Name, @Surname)
      DECLARE @ParticipantID INT = SCOPE_IDENTITY()
      INSERT INTO ParticipantsDetails VALUES(@ParticipantID, @Email)
      INSERT INTO ParticipRegByClients VALUES(@ClientID, @ParticipantID)
    COMMIT
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
    BEGIN TRY
        DECLARE @ParticipantIDFOUND INT = (
          SELECT pd.ParticipantID FROM ParticipantsDetails pd JOIN Participants p
              ON p.ParticipantID = pd.ParticipantID WHERE Email = @Email AND p.Name = @Name AND p.Surname = @Surname
              AND (p.PESEL IS NULL OR p.PESEL = @PESEL OR @PESEL IS NULL)
          UNION
          SELECT id.ParticipantID FROM Clients c JOIN IndividualsDetails id ON c.ClientID = id.ClientID
            JOIN Participants p ON id.ParticipantID = p.ParticipantID
          WHERE Email = @Email AND p.Name = @Name AND p.Surname = @Surname
              AND (p.PESEL IS NULL OR p.PESEL = @PESEL OR @PESEL IS NULL)
        )
        IF @ParticipantIDFOUND IS NOT NULL
        BEGIN
          BEGIN TRY
            BEGIN TRANSACTION
            UPDATE Participants SET PESEL = @PESEL WHERE ParticipantID = @ParticipantIDFOUND
            INSERT INTO ParticipRegByClients VALUES (@ClientID, @ParticipantIDFOUND)
            COMMIT
          END TRY
          BEGIN CATCH
            -- empty catch left on purpose
          END CATCH
        END
        ELSE
        BEGIN
          RAISERROR('Email is already used in system.', 16, 1)
        END
    END TRY
    BEGIN CATCH
      -- empty catch left on purpose
    END CATCH
    DECLARE @ErrorMessage2 nvarchar(4000),  @ErrorSeverity2 int;
    SELECT @ErrorMessage2 = ERROR_MESSAGE(),@ErrorSeverity2 = ERROR_SEVERITY();
    RAISERROR(@ErrorMessage2, @ErrorSeverity2, 1);
  END CATCH
END
