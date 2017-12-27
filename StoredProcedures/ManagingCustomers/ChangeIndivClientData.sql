-- Changing IndivClient data
DROP PROCEDURE ChangeIndivClientData
CREATE PROCEDURE ChangeIndivClientData
  (
    @ClientID INT,
    @Login VARCHAR(45),
    @Password VARCHAR(64),
    @Email VARCHAR(80),
    @PhoneNumber VARCHAR(16),
    @PESEL VARCHAR(11),
    @Name VARCHAR(32),
    @Surname VARCHAR(32)
  )
AS
BEGIN
  BEGIN TRY
      BEGIN TRANSACTION
      UPDATE Clients SET Login = @Login, Password = HASHBYTES('SHA2_512', @Password), Email = @Email, PhoneNumber = @PhoneNumber
      WHERE ClientID = @ClientID
      UPDATE Participants SET PESEL = @PESEL, Name = @Name, Surname = @Surname
      WHERE ParticipantID = (SELECT ParticipantID FROM IndividualsDetails WHERE ClientID = @ClientID)
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
