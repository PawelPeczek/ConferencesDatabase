CREATE VIEW dbo.[PopularWorkshopsView]
AS
SELECT  w.[WorkshopID] AS 'ID', w.[Name] AS 'Name' , SUM(wso.[NumberOfSeats]) AS 'SeatsAmounts'
FROM [Workshops] w
	LEFT JOIN WorkshopsSubOrders wso ON w.[WorkshopID] = wso.[WorkshopID]
GROUP BY  w.[WorkshopID] ,w.[Name]