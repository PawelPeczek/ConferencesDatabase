-- inserting a CompanyClient
CREATE PROCEDURE CreateCompanyClient
  (
    @Login VARCHAR(45),
    @Password VARCHAR(64),
    @Email VARCHAR(80),
    @PhoneNumber VARCHAR(16),
    @CompanyName VARCHAR(45),
    @Fax VARCHAR(16),
    @NIP VARCHAR(13),
    @ContactPersonName VARCHAR(32) = NULL,
    @ContactPersonSurname VARCHAR(32) = NULL
  )
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
      INSERT INTO Clients VALUES (@Login, HASHBYTES('SHA2_512', @Password), @Email, @PhoneNumber)
      INSERT INTO CompDetails VALUES(SCOPE_IDENTITY(), @CompanyName, @Fax, @NIP, @ContactPersonName, @ContactPersonSurname)
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
