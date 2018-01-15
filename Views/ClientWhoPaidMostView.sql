CREATE VIEW ClientWhoPaidMostView
AS
SELECT t1.ClientID AS ' Who', CAST(SUM([PaidForWorkshops]+[PaidForConferences]) AS DECIMAL (15,2)) AS 'Paid'
FROM (SELECT o.ClientID,w.Name, SUM(wso.NumberOfSeats*w.Value) AS 'PaidForWorkshops'
FROM Orders o JOIN OrdersOnConfDays oocd ON o.OrderID =oocd.OrderID
	JOIN WorkshopsSubOrders wso ON wso.OrdOnConfDayID = oocd.OrdOnConfDayID
	JOIN DaysOfConf doc ON doc.DayOfConfID =oocd.DayOfConfID
	JOIN Workshops w ON w.WorkshopID = wso.WorkshopID
WHERE o.Status=0
GROUP BY o.ClientID, w.Name) AS t1
JOIN
(SELECT con.ConfName ,o.ClientID, 
SUM(pt.Value*(oocd.NumberOfRegularSeats + oocd.NumberOfStudentSeats*(1-con.StudentDiscount))) AS 'PaidForConferences'
FROM Conferences con
JOIN DaysOfConf doc ON con.ConfID = doc.ConfID
JOIN PriceThresholds pt ON pt.DayOfConfID = doc.DayOfConfID
JOIN OrdersOnConfDays oocd ON oocd.DayOfConfID = doc.DayOfConfID
JOIN Orders o ON o.OrderID = oocd.OrderID
WHERE o.Status=0
GROUP BY o.ClientID, con.ConfName) t2
ON t1.ClientID = t2.ClientID
GROUP BY t1.ClientID