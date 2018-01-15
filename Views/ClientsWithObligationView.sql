CREATE VIEW ClientsWithObligationView
AS
SELECT bsi.ClientID, bsi.[Contact Person] , bsi.PhoneNumber, SUM(t.Total) - SUM(pay.Value) [Obligation]
FROM BasicClientsInfo bsi 
JOIN Orders o ON bsi.ClientID = o.ClientID
JOIN GetValueOfAllOrders() t ON t.OrderId = o.OrderID
JOIN Payments pay ON pay.OrderID = o.OrderID
GROUP BY bsi.ClientID, bsi.[Contact Person], bsi.PhoneNumber
HAVING SUM(t.Total) - SUM(pay.Value) > 0