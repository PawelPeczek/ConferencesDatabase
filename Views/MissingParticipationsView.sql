CREATE VIEW MissingParticipationsView
AS
SELECT bci.*, t.* FROM BasicClientsInfo bci
JOIN Orders o ON o.ClientID = bci.ClientID JOIN
MissingParticipantsForOrder() t ON t.OrderId = o.OrderId