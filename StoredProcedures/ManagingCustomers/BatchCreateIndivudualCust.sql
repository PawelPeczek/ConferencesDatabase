-- batch creating clients
-- Doesn't support promotion participant to IndividualCustomer -
-- to do so -> use CreateIndivudualCust procedure
DROP TYPE CUSTOMERS_INFO
CREATE TYPE CUSTOMERS_INFO AS TABLE(
    internalID INT IDENTITY (1,1),
    Login VARCHAR(45),
    Password VARCHAR(64),
    Email VARCHAR(80),
    PhoneNumber VARCHAR(16),
    PESEL VARCHAR(11),
    Name VARCHAR(32),
    Surname VARCHAR(32),
    StudentCardNumber VARCHAR(16) DEFAULT NULL,
    FromDate DATE DEFAULT NULL,
    ToDate DATE DEFAULT NULL
)

DROP PROCEDURE BatchCreateIndivudualCust
CREATE PROCEDURE BatchCreateIndivudualCust
    @Customers CUSTOMERS_INFO READONLY
AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION
    DECLARE @CIDs TABLE(
      internalID INT IDENTITY(1, 1),
      ClientID INT
    )
    DECLARE @PIDs TABLE(
      internalID INT IDENTITY(1, 1),
      ParticipantID INT
    )

    INSERT INTO Clients
    OUTPUT inserted.ClientID INTO @CIDs(ClientID)
    SELECT c.Login, HASHBYTES('SHA2_512', c.Password), c.Email, c.PhoneNumber FROM @Customers c

    INSERT INTO Participants
    OUTPUT inserted.ParticipantID INTO @PIDs(ParticipantID)
    SELECT c.PESEL, c.Name, c.Surname FROM @Customers c

    INSERT INTO IndividualsDetails SELECT t1.ClientID, t2.ParticipantID FROM @CIDs t1 JOIN @PIDs t2 ON t1.internalID = t2.internalID
    INSERT INTO ParticipRegByClients  SELECT t1.ClientID, t2.ParticipantID FROM @CIDs t1 JOIN @PIDs t2 ON t1.internalID = t2.internalID
    INSERT INTO StudentCards SELECT p.ParticipantID, c.StudentCardNumber, c.FromDate, c.ToDate FROM @PIDs p JOIN @Customers c ON c.internalID = p.internalID
    WHERE c.StudentCardNumber IS NOT NULL AND FromDate IS NOT NULL AND ToDate IS NOT NULL
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