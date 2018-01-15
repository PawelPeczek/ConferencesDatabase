
CREATE INDEX IX_OrdersCD ON dbo.Orders (ClientID ASC, DateOfBook DESC)
CREATE INDEX IX_OrdersC ON dbo.Orders (ClientID ASC)
CREATE INDEX IX_OrdersD ON dbo.Orders (DateOfBook DESC)

CREATE INDEX IX_ReturnsOD ON dbo.Returns (OrderID ASC, Date DESC)
CREATE INDEX IX_ReturnsO ON dbo.Returns (OrderID ASC)
CREATE INDEX IX_ReturnsD ON dbo.Returns (Date DESC)

CREATE INDEX IX_PaymentsOD ON dbo.Payments (OrderID ASC, Date DESC)
CREATE INDEX IX_PaymentsO ON dbo.Payments (OrderID ASC)
CREATE INDEX IX_PaymentsD ON dbo.Payments (Date DESC)

CREATE INDEX IX_DaysOfConfCD ON dbo.DaysOfConf (ConfID ASC, Date DESC)
CREATE INDEX IX_DaysOfConfC ON dbo.DaysOfConf (ConfID ASC)

CREATE INDEX IX_PriceThresholdsDoc ON dbo.PriceThresholds (DayOfConfID ASC)

CREATE INDEX IX_StudentCardsP ON dbo.StudentCards (ParticipantID ASC)

CREATE INDEX IX_Workshops ON dbo.Workshops (DayOfConfID ASC)

CREATE INDEX IX_WorkshopsSubOrdersOocd ON dbo.WorkshopsSubOrders (OrdOnConfDayID ASC)

CREATE INDEX IX_OrdersOnConfDaysO ON dbo.OrdersOnConfDays (OrderID ASC)
CREATE INDEX IX_OrdersOnConfDaysDoc ON dbo.OrdersOnConfDays (DayOfConfID ASC)
