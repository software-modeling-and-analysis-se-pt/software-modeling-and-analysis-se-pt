-- Server Procedures

EXEC Orders.usp_CreateOrder
    @UserId = 7,
    @PaymentMethod = 'Credit Card',
    @Currency = 'EUR',
    @GameIds = '1,2,5';

EXEC Orders.usp_UpdateOrderStatus @OrderId = 12, @NewStatus = 'Completed';

SELECT * FROM Orders.Orders WHERE OrderId = 12;
SELECT * FROM Orders.OrderItems WHERE OrderId = 12;

-- Functions

SELECT Users.fn_GetUserTotalSpent(3) AS TotalSpent;

SELECT Games.fn_GetGameAverageRating(8) AS AvgRating;

-- Triggers will deduct balance on order completion and will set completed at