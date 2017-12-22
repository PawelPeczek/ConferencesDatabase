-----------------------------------------
--        DELETING DATABASE
-----------------------------------------

ALTER TABLE CompDetails DROP CONSTRAINT FK_CompDetails_Clients
ALTER TABLE IndividualsDetails DROP CONSTRAINT FK_IndividualsDetails_Clients
ALTER TABLE IndividualsDetails DROP CONSTRAINT FK_IndividualsDetails_Participants
ALTER TABLE Orders DROP CONSTRAINT FK_Orders_Clients
ALTER TABLE Payments DROP CONSTRAINT FK_Payments_Orders
ALTER TABLE DaysOfConf DROP CONSTRAINT FK_DaysOfConf_Conferences
ALTER TABLE PriceThresholds DROP CONSTRAINT FK_PriceThresholds_DaysOfConf
ALTER TABLE OrdersOnConfDays DROP CONSTRAINT FK_OrdersOnConfDays_DaysOfConf
ALTER TABLE OrdersOnConfDays DROP CONSTRAINT FK_OrdersOnConfDays_Orders
ALTER TABLE Workshops DROP CONSTRAINT FK_Workshops_DaysOfConf
ALTER TABLE WorkshopsSubOrders DROP CONSTRAINT FK_WorkshopsSubOrders_OrdersOnConfDays
ALTER TABLE WorkshopsSubOrders DROP CONSTRAINT FK_WorkshopsSubOrders_Workshops
ALTER TABLE ParticipAtConfDay DROP CONSTRAINT FK_ParticipAtConfDay_OrdersOnConfDays
ALTER TABLE ParticipAtConfDay DROP CONSTRAINT FK_ParticipAtConfDay_Participants
ALTER TABLE ParticipantsAtWorkshops DROP CONSTRAINT FK_ParticipantsAtWorkshops_ParticipAtConfDay
ALTER TABLE ParticipantsAtWorkshops DROP CONSTRAINT FK_ParticipantsAtWorkshops_WorkshopsSubOrders
ALTER TABLE ParticipantsDetails DROP CONSTRAINT FK_ParticipantsDetails_Participants
ALTER TABLE StudentCards DROP CONSTRAINT FK_StudentCards_Participants
ALTER TABLE ParticipRegByClients DROP CONSTRAINT FK_ParticipRegByClients_Clients
ALTER TABLE ParticipRegByClients DROP CONSTRAINT FK_ParticipRegByClients_Participants
DROP TABLE Clients
DROP TABLE CompDetails
DROP TABLE IndividualsDetails
DROP TABLE Orders
DROP TABLE Payments
DROP TABLE Conferences
DROP TABLE DaysOfConf
DROP TABLE PriceThresholds
DROP TABLE WorkshopsSubOrders
DROP TABLE ParticipantsAtWorkshops
DROP TABLE ParticipAtConfDay
DROP TABLE Workshops
DROP TABLE Participants
DROP TABLE OrdersOnConfDays
DROP TABLE ParticipantsDetails
DROP TABLE StudentCards
DROP TABLE ParticipRegByClients