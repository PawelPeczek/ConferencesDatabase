-- create company in batches
DROP TYPE COMPANY_INFO
CREATE TYPE COMPANY_INFO AS TABLE(
    internalID INT IDENTITY (1,1),
    Login VARCHAR(45),
    Password VARCHAR(64),
    Email VARCHAR(80),
    PhoneNumber VARCHAR(16),
    CompanyName VARCHAR(45) NOT NULL,
    Fax VARCHAR(16),
    NIP VARCHAR(13) NOT NULL,
    ContactPersonName VARCHAR(32) DEFAULT NULL,
    ContactPersonSurname VARCHAR(32) DEFAULT NULL
)

DROP PROCEDURE BatchCreateCompanyCust
CREATE PROCEDURE BatchCreateCompanyCust
    @Customers COMPANY_INFO READONLY
AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION
    DECLARE @CIDs TABLE(
      internalID INT IDENTITY(1, 1),
      ClientID INT
    )


    INSERT INTO Clients
    OUTPUT inserted.ClientID INTO @CIDs(ClientID)
    SELECT c.Login, HASHBYTES('SHA2_512', c.Password), c.Email, c.PhoneNumber FROM @Customers c

    INSERT INTO CompDetails
    SELECT cid.ClientID, c.CompanyName, c.FAX, c.NIP, c.ContactPersonName, c.ContactPersonSurname
    FROM @Customers c JOIN @CIDs cid ON c.internalID = cid.internalID

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
