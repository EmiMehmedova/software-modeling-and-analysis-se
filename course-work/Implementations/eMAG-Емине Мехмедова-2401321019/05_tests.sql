USE eMAG;
GO

-- 0) ПОЧИСТВАНЕ
--    Изтрива тестовия продукт от поръчка 1, ако е останал от предишно пускане.
--    Така скриптът може да се пуска много пъти.
--    (тригерът сам връща сумата на поръчка 1 обратно)
DELETE FROM OrderItems
WHERE OrderID = 1 AND ProductID = 20;
GO

-- 1) ФУНКЦИЯ: колко общо е похарчил клиент 1
--    Проверява, че функцията сумира поръчките на клиента
--    (без отказаните) -> 1727.00
SELECT dbo.fn_CustomerTotalSpent(1) AS TotalSpent;
GO

-- 2) ФУНКЦИЯ: клиент, който не съществува
--    Проверява, че функцията връща 0, а не NULL или грешка -> 0.00
SELECT dbo.fn_CustomerTotalSpent(999) AS TotalSpent;
GO

-- 3) ПРОЦЕДУРА: всички поръчки на клиент 1
--    Проверява, че процедурата показва поръчките с продуктите в тях
--    -> 3 реда (поръчки 28 и 35)
EXEC dbo.sp_GetCustomerOrders @CustomerID = 1;
GO

-- 4) ПРОЦЕДУРА: клиент, който не съществува
--    Проверява, че процедурата не дава грешка, а просто няма резултат
--    -> 0 реда
EXEC dbo.sp_GetCustomerOrders @CustomerID = 999;
GO

-- 5) ТРИГЕР при INSERT: добавяме продукт в поръчка
--    Добавяме Xbox Series S (549.00) към поръчка 1.
--    Проверява, че тригерът сам увеличава общата сума на поръчката
--    -> TotalAmount: 948.99 -> 1497.99
SELECT OrderID, TotalAmount AS BeforeInsert FROM Orders WHERE OrderID = 1;

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES (1, 20, 1, 549.00);

SELECT OrderID, TotalAmount AS AfterInsert FROM Orders WHERE OrderID = 1;
GO

-- 6) ТРИГЕР при UPDATE: променяме количеството
--    Правим количеството на Xbox-а 2 броя.
--    Проверява, че тригерът преизчислява сумата при промяна
--    -> TotalAmount: 1497.99 -> 2046.99
UPDATE OrderItems
SET Quantity = 2
WHERE OrderID = 1 AND ProductID = 20;

SELECT OrderID, TotalAmount AS AfterUpdate FROM Orders WHERE OrderID = 1;
GO

-- 7) ТРИГЕР + ФУНКЦИЯ заедно
--    Поръчка 1 е на клиент 9. Тъй като тригерът е обновил сумата,
--    функцията вече показва новата, по-голяма сума за клиента
--    -> 3346.97
SELECT dbo.fn_CustomerTotalSpent(9) AS TotalSpent;
GO

-- 8) ТРИГЕР при DELETE: махаме продукта от поръчката
--    Проверява, че тригерът намалява сумата, когато се изтрие продукт
--    -> TotalAmount: 2046.99 -> 948.99
DELETE FROM OrderItems
WHERE OrderID = 1 AND ProductID = 20;

SELECT OrderID, TotalAmount AS AfterDelete FROM Orders WHERE OrderID = 1;
GO

-- 9) РЕЗУЛТАТ: поръчка 1 е както в началото
--    Показва продуктите в поръчка 1 и сумата ѝ,
--    за да се види, че данните не са променени след теста
--    -> 2 продукта, TotalAmount = 948.99
SELECT o.OrderID, p.ProductName, oi.Quantity, oi.UnitPrice, o.TotalAmount
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p    ON oi.ProductID = p.ProductID
WHERE o.OrderID = 1;
GO
