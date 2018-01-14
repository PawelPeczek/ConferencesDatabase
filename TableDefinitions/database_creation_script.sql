CREATE TABLE Clients(
  ClientID INT PRIMARY KEY IDENTITY(1,1),
  Login VARCHAR(45) UNIQUE NOT NULL,
  Password VARBINARY(64) NOT NULL,
  Email VARCHAR(80) NOT NULL UNIQUE,
  PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
  CHECK (
    Email LIKE '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%'
    AND Email NOT LIKE '% %'
    AND PhoneNumber NOT LIKE '%[a-z,.,_,*,!,@,#,$,%,^,&,*,;,",~,/,\,|,=]%'
    AND LEN(PhoneNumber) >= 9
  )
)

CREATE TABLE CompDetails(
  ClientID INT PRIMARY KEY,
  CompanyName VARCHAR(45) NOT NULL,
  Fax VARCHAR(20),
  NIP VARCHAR(13) UNIQUE NOT NULL,
  ContactPersonName VARCHAR(32),
  ContactPersonSurname VARCHAR(32),
  CONSTRAINT FK_CompDetails_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
  CHECK (
    Fax NOT LIKE '%[a-z,.,_,*,!,@,#,$,%,^,&,*,;,",~,/,\,|,=]%' AND
    NIP LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
    AND LEN(Fax) >= 9
  )
)

CREATE TABLE Participants(
    ParticipantID INT PRIMARY KEY IDENTITY(1,1),
    PESEL VARCHAR(11),                    -- Combination
    Name VARCHAR(32) NOT NULL,            -- of this three
    Surname VARCHAR(32) NOT NULL,         -- must be unique - but only when PESEL is given
    CHECK (
     (PESEL LIKE '[0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z]' --Passports
      OR PESEL LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' -- PESEL
      OR PESEL IS NULL) -- Null value if sth else
    )
)
-- ALTER TABLE ParticipRegByClients ADD CONSTRAINT  UNIQUE_CLientID_ParticipantID UNIQUE (ClientID, ParticipantID)
CREATE TABLE ParticipRegByClients(
  ClientID INT,
  ParticipantID INT,
  CONSTRAINT PK_ParticipRegByClients PRIMARY KEY (ClientID, ParticipantID),
  CONSTRAINT FK_ParticipRegByClients_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
  CONSTRAINT FK_ParticipRegByClients_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
)


CREATE TABLE StudentCards(
  StudentCardID INT PRIMARY KEY IDENTITY(1, 1),
  ParticipantID INT NOT NULL,
  StudentCardNumber VARCHAR(16) NOT NULL,
  FromDate DATE NOT NULL,
  ToDate DATE NOT NULL,
  CONSTRAINT FK_StudentCards_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
  CHECK(
    YEAR(FromDate) >= 2009 AND -- Year before starting 2010
    YEAR(ToDate) >= 2009 AND
    ToDate > FromDate AND
    DATEDIFF(MONTH, FromDate, ToDate) <= 6 -- Student Card is valid only one term
    AND YEAR(ToDate) <= YEAR(GETDATE()) + 1
  )
)

CREATE TABLE IndividualsDetails(
  ClientID INT UNIQUE,
  ParticipantID INT UNIQUE,
  PRIMARY KEY (ClientID, ParticipantID),
  CONSTRAINT FK_IndividualsDetails_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
  CONSTRAINT FK_IndividualsDetails_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID)
)

CREATE TABLE Orders(
  OrderID INT PRIMARY KEY IDENTITY(1,1),
  ClientID INT NOT NULL,
  DateOfBook DATE NOT NULL DEFAULT GETDATE(),
  Status BIT DEFAULT 0 NOT NULL,
  CONSTRAINT FK_Orders_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
  CHECK (
    Status IN (0, 1) -- 0 -> Active, 1 -> Canceled
    AND YEAR(DateOfBook) >= 2010 -- some Fixed Year when the company starts
    AND DateOfBook <= GETDATE()
    )
)

CREATE TABLE Payments(
  PaymentID INT PRIMARY KEY IDENTITY(1,1),
  OrderID INT NOT NULL,
  Date DATE NOT NULL DEFAULT GETDATE(),
  Value DECIMAL(8, 2) NOT NULL,
  AccountNumber VARCHAR(28) NOT NULL, -- IBAN i NRB
  TitleOfPayment VARCHAR(140) NOT NULL,
  TransferSender VARCHAR(70) NOT NULL,
  CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CHECK (
    Value > 0 AND
         (
           AccountNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' +
                            '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
           AccountNumber LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' +
                               '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
         ) AND
    YEAR(Date) > 2010 AND
    Date <= GETDATE()
    )
)

CREATE TABLE Returns(
  ReturnID INT PRIMARY KEY IDENTITY (1, 1),
  OrderID INT NOT NULL,
  Date DATE NOT NULL DEFAULT GETDATE(),
  Value DECIMAL(8, 2) NOT NULL,
  AccountNumber VARCHAR(28) NOT NULL,
  TitleOfPayment VARCHAR(140) NOT NULL,
  CONSTRAINT FK_Returns_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CHECK (
    Value > 0 AND
         (
           AccountNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' +
                            '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
           AccountNumber LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' +
                               '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
         ) AND
    YEAR(Date) > 2010 AND
    Date <= GETDATE()
    )
)

CREATE TABLE ParticipantsDetails(
  ParticipantID INT PRIMARY KEY,
  Email VARCHAR(80) NOT NULL UNIQUE,
  CONSTRAINT FK_ParticipantsDetails_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
  CHECK (
    Email LIKE '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%'
    AND Email NOT LIKE '% %'
    )
)

CREATE TABLE Conferences(
  ConfID INT PRIMARY KEY IDENTITY(1,1),
  ConfName VARCHAR(120) NOT NULL,
  ConfTopic VARCHAR(256),
  ConfDescription VARCHAR(512),
  StudentDiscount REAL NOT NULL DEFAULT 0
  CHECK (
    StudentDiscount BETWEEN 0 AND 1
  )
)

CREATE TABLE DaysOfConf(
  DayOfConfID INT PRIMARY KEY IDENTITY(1,1),
  ConfID INT NOT NULL,
  Date DATE NOT NULL,
  SpaceLimit SMALLINT NOT NULL,
  CONSTRAINT FK_DaysOfConf_Conferences FOREIGN KEY (ConfID) REFERENCES Conferences(ConfID),
  CONSTRAINT UNIQUE_ConfID_Date UNIQUE (ConfID, Date),
  CHECK (
    YEAR(Date) > 2010 AND
    SpaceLimit > 0
  )
)

CREATE TABLE PriceThresholds(
  ThresholdID INT PRIMARY KEY IDENTITY(1,1),
  DayOfConfID INT NOT NULL,
  EndDate DATE NOT NULL,
  Value DECIMAL(8, 2) NOT NULL,
  CONSTRAINT FK_PriceThresholds_DaysOfConf FOREIGN KEY (DayOfConfID) REFERENCES DaysOfConf(DayOfConfID),
  CONSTRAINT UNIQUE_DayOfConf_EndThreshold UNIQUE(EndDate, DayOfConfID),
  CHECK (
    Value >= 0
  )
)

CREATE TABLE Workshops(
  WorkshopID INT PRIMARY KEY IDENTITY(1,1),
  DayOfConfID INT NOT NULL,
  Name VARCHAR(120) NOT NULL,
  TeacherName VARCHAR(32),
  TeacherSurname VARCHAR(32),
  Value DECIMAL(8, 2) NOT NULL,
  StartTime TIME(0) NOT NULL,
  EndTime TIME(0) NOT NULL,
  SpaceLimit SMALLINT NOT NULL,
  CONSTRAINT FK_Workshops_DaysOfConf FOREIGN KEY (DayOfConfID) REFERENCES DaysOfConf(DayOfConfID),
  CHECK (
    Value >= 0 AND
    StartTime < EndTime AND
    SpaceLimit > 0
  )
)

CREATE TABLE OrdersOnConfDays(
  OrdOnConfDayID INT PRIMARY KEY IDENTITY(1,1),
  DayOfConfID INT NOT NULL,
  OrderID INT NOT NULL,
  NumberOfRegularSeats SMALLINT NOT NULL,
  NumberOfStudentSeats SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT FK_OrdersOnConfDays_DaysOfConf FOREIGN KEY (DayOfConfID) REFERENCES DaysOfConf(DayOfConfID),
  CONSTRAINT FK_OrdersOnConfDays_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT UNIQUE_DayOfConfID_OrderID UNIQUE (DayOfConfID, OrderID),
  -- One Order can have multiple Days - the same with Conf Day, but the combination of DayOfConfID
  -- and OrderID should be unique for clarity
  CHECK (
    (NumberOfRegularSeats >= 0 AND NumberOfStudentSeats >= 0) AND
    (NumberOfRegularSeats > 0 OR NumberOfStudentSeats > 0)
  )
)

CREATE TABLE ParticipAtConfDay(
  EntryID INT PRIMARY KEY IDENTITY(1,1),
  ParticipantID INT NOT NULL,
  OrdOnConfDayID INT NOT NULL,
  CONSTRAINT FK_ParticipAtConfDay_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
  CONSTRAINT FK_ParticipAtConfDay_OrdersOnConfDays  FOREIGN KEY (OrdOnConfDayID) REFERENCES OrdersOnConfDays(OrdOnConfDayID),
  CONSTRAINT UNIQUE_ParticipantID_OrdOnConfDayID UNIQUE (ParticipantID, OrdOnConfDayID)
  -- One Participant can be assigned to many days - and vice versa
  -- but one participant can be assigned only once to Order on conf days
)

CREATE TABLE WorkshopsSubOrders(
  WorkshopSubOrderID INT PRIMARY KEY IDENTITY(1,1),
  WorkshopID INT NOT NULL,
  OrdOnConfDayID INT NOT NULL,
  NumberOfSeats SMALLINT NOT NULL,
  CONSTRAINT FK_WorkshopsSubOrders_Workshops FOREIGN KEY (WorkshopID) REFERENCES Workshops(WorkshopID),
  CONSTRAINT FK_WorkshopsSubOrders_OrdersOnConfDays FOREIGN KEY (OrdOnConfDayID) REFERENCES OrdersOnConfDays(OrdOnConfDayID),
  CONSTRAINT UNIQUE_WorkshopID_OrdOnConfDayID UNIQUE(WorkshopID, OrdOnConfDayID),
  CHECK (
    NumberOfSeats > 0
  )
)

CREATE TABLE ParticipantsAtWorkshops(
  EntryID INT,
  WorkshopSubOrderID INT,
  PRIMARY KEY (EntryID, WorkshopSubOrderID),
  CONSTRAINT FK_ParticipantsAtWorkshops_ParticipAtConfDay FOREIGN KEY (EntryID) REFERENCES ParticipAtConfDay(EntryID),
  CONSTRAINT FK_ParticipantsAtWorkshops_WorkshopsSubOrders FOREIGN KEY (WorkshopSubOrderID) REFERENCES WorkshopsSubOrders(WorkshopSubOrderID)
)
