CREATE VIEW dbo.[PopularConfView] 
AS 	
SELECT c.[ConfID] AS 'ID', c.[ConfName] AS 'Name',  SUM(oocd.[NumberOfRegularSeats] + oocd.[NumberOfStudentSeats]) AS 'SeatsAmount'
FROM [Conferences] c
	LEFT JOIN dbo.[DaysOfConf] dof ON c.[ConfID]=dof.[ConfID]
	LEFT JOIN dbo.[OrdersOnConfDays] oocd ON dof.[DayOfConfID]=oocd.DayOfConfID
GROUP BY c.[ConfID], c.[ConfName]
