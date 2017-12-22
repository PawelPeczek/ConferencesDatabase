-- checking if any free seats at workshop
CREATE TRIGGER WorkshopSpaceCheck
  ON WorkshopsSubOrders
  AFTER INSERT, UPDATE
  AS
  BEGIN
    DECLARE @num_of_vio AS INT = (
      SELECT COUNT(t1.WorkshopID)
        FROM (
            SELECT a.WorkshopID, SUM(wso.NumberOfSeats) [SumOfSeats]
            FROM (SELECT DISTINCT WorkshopID from inserted) a
            JOIN WorkshopsSubOrders wso ON a.WorkshopID = wso.WorkshopID
            GROUP BY a.WorkshopID
           ) t1
        JOIN (
            SELECT w.WorkshopID, w.SpaceLimit
            FROM Workshops w JOIN (SELECT DISTINCT WorkshopID from inserted) i ON w.WorkshopID = i.WorkshopID
          ) t2 ON t1.WorkshopID = t2.WorkshopID
        WHERE SpaceLimit - t1.SumOfSeats < 0
     )

    IF @num_of_vio > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Requested number of seats at workshop exceed available space!', 16, 5)
      END
  END


-- TRIGGER WorkshopSpaceCheck TESTS

UPDATE DaysOfConf SET SpaceLimit = 10
DELETE FROM WorkshopsSubOrders
SELECT * FROM WorkshopsSubOrders
SELECT * FROM OrdersOnConfDays
INSERT INTO WorkshopsSubOrders VALUES
  (7, 20, 5)
INSERT INTO WorkshopsSubOrders VALUES
  (7, 22, 6)

-- TESTS end
