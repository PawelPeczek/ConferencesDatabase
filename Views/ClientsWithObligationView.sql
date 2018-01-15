CREATE VIEW ClientsWithObligationView
AS
SELECT o1.ClientID, t1.OrderID , CAST(SUM([PaidForWorkshops]+[PaidForConferences]) AS DECIMAL (15,2)) AS 'ForPaid',
	SUM(p.Value) AS 'Paid',CAST(SUM([PaidForWorkshops]+[PaidForConferences]) - SUM(p.Value)AS DECIMAL (15,2)) AS 'Balance'

FROM (SELECT o.OrderID,w.Name, SUM(wso.NumberOfSeats*w.Value) AS 'PaidForWorkshops'
FROM Orders o JOIN OrdersOnConfDays oocd ON o.OrderID =oocd.OrderID
	JOIN WorkshopsSubOrders wso ON wso.OrdOnConfDayID = oocd.OrdOnConfDayID
	JOIN DaysOfConf doc ON doc.DayOfConfID =oocd.DayOfConfID
	JOIN Workshops w ON w.WorkshopID = wso.WorkshopID
WHERE o.Status=0
GROUP BY o.OrderID, w.Name) AS t1
JOIN
(SELECT con.ConfName ,o.OrderID, 
SUM(pt.Value*(oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats*(1-con.StudentDiscount))) AS 'PaidForConferences'
FROM Conferences con
JOIN DaysOfConf doc ON con.ConfID = doc.ConfID
JOIN PriceThresholds pt ON pt.DayOfConfID = doc.DayOfConfID
JOIN OrdersOnConfDays oocd ON oocd.DayOfConfID = doc.DayOfConfID
JOIN Orders o ON o.OrderID = oocd.OrderID
WHERE o.Status=0
GROUP BY o.OrderID, con.ConfName) t2
ON t1.OrderID = t2.OrderID
JOIN Payments p ON p.OrderID = t1.OrderID
JOIN Orders o1 ON o1.OrderID = t1.OrderID
GROUP BY t1.OrderID,o1.ClientID
HAVING SUM([PaidForWorkshops]+[PaidForConferences]) > SUM(p.Value)