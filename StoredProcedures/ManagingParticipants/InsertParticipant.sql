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
          IF @PESEL IS NOT NULL
            UPDATE Participants SET PESEL = @PESEL WHERE ParticipantID = @ParticipantIDFOUND
          INSERT INTO ParticipRegByClients VALUES (@ClientID, @ParticipantIDFOUND)
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
      ELSE
      BEGIN
        RAISERROR('Email is already used in system.', 16, 1)
      END
  END CATCH
END
