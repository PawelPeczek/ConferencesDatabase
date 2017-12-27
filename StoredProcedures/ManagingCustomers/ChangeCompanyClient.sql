-- Changing ClientInfo
CREATE PROCEDURE ChangeCompanyClient
  (
    @ClientID INT,
    @Login VARCHAR(45),
    @Password VARCHAR(64),
    @Email VARCHAR(80),
    @PhoneNumber VARCHAR(16),
    @CompanyName VARCHAR(45),
    @Fax VARCHAR(16),
    @NIP VARCHAR(13),
    @ContactPersonName VARCHAR(32) = NULL,
    @ContactPersonSurname VARCHAR(32)
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      UPDATE Clients SET Login = @Login, Password = HASHBYTES('SHA2_512', @Password), Email = @Email,
        PhoneNumber = @PhoneNumber WHERE ClientID = @ClientID
      UPDATE CompDetails SET CompanyName = @CompanyName, Fax = @Fax, NIP = @NIP,
        ContactPersonName = @ContactPersonName, ContactPersonSurname = @ContactPersonSurname WHERE ClientID = @ClientID
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
