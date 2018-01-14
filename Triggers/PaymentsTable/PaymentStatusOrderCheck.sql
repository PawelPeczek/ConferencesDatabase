DROP TRIGGER PaymentStatusOrderCheck
CREATE TRIGGER PaymentStatusOrderCheck

	ON Payments
	AFTER INSERT, UPDATE
	AS
	BEGIN
	  DECLARE @num_of_valid INT = (
	      SELECT COUNT(*)
	    FROM inserted i JOIN Orders o ON o.OrderID = i.OrderID AND o.Status = 1
	  )
	  IF @num_of_valid <> 0
	    BEGIN
	        ROLLBACK TRANSACTION
	        RAISERROR('Payment cannot be add if order status is cancelled.', 16, 14)
	    END
	END

