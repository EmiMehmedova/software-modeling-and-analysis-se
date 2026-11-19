-- =============================================
-- eMAG - Съхранена процедура, функция и тригер
-- =============================================

USE eMAG;
GO

-- =============================================
-- 1. ФУНКЦИЯ: Колко общо е похарчил даден клиент
-- =============================================
CREATE FUNCTION dbo.fn_CustomerTotalSpent (@CustomerID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = SUM(TotalAmount)
    FROM Orders
    WHERE CustomerID = @CustomerID
      AND Status <> N'Отказана';

    RETURN ISNULL(@Total, 0);
END;
GO

-- =============================================
-- 2. СЪХРАНЕНА ПРОЦЕДУРА: Всички поръчки на даден клиент
-- =============================================
CREATE PROCEDURE dbo.sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT
        o.OrderID,
        o.OrderDate,
        o.Status,
        p.ProductName,
        oi.Quantity,
        oi.UnitPrice,
        o.TotalAmount
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    JOIN Products p    ON oi.ProductID = p.ProductID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate;
END;
GO

-- =============================================
-- 3. ТРИГЕР: Автоматично преизчислява TotalAmount на поръчката,
--    когато се добави, промени или изтрие продукт от нея
-- =============================================
CREATE TRIGGER trg_UpdateOrderTotal
ON OrderItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Orders
    SET TotalAmount = ISNULL((
        SELECT SUM(Quantity * UnitPrice)
        FROM OrderItems
        WHERE OrderItems.OrderID = Orders.OrderID
    ), 0)
    WHERE OrderID IN (
        SELECT OrderID FROM inserted
        UNION
        SELECT OrderID FROM deleted
    );
END;
GO


-- =============================================
-- ТЕСТВАНЕ (маркирай съответния ред и натисни F5)
-- =============================================

-- Тест на функцията: колко е похарчил клиент 1
SELECT FirstName, LastName, dbo.fn_CustomerTotalSpent(CustomerID) AS TotalSpent
FROM Customers;

-- Тест на процедурата: поръчките на клиент 1
EXEC dbo.sp_GetCustomerOrders @CustomerID = 1;

-- Тест на тригера:
-- 1) Виж сумата на поръчка 1 преди промяната (699.00)
SELECT OrderID, TotalAmount FROM Orders WHERE OrderID = 1;

-- 2) Добави Philips Airfryer (249.99) към поръчка 1
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES (1, 15, 1, 249.99);

-- 3) Виж сумата отново: тригерът я е обновил сам (948.99)
SELECT OrderID, TotalAmount FROM Orders WHERE OrderID = 1;
