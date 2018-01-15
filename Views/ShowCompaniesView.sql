CREATE VIEW ShowCompaniesView
AS
SELECT c.ClientID,cd.CompanyName, c.Email,c.PhoneNumber, c.Login, c.Password,
	CONCAT(cd.ContactPersonName,' ',cd.ContactPersonSurname) AS 'Contact Person'
FROM Clients c
JOIN CompDetails cd ON c.ClientID = cd.ClientID