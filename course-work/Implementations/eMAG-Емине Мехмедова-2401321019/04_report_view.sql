-- =============================================
-- eMAG - Изглед (VIEW) с данни за Power BI доклада
-- Събира всички продажби в една таблица
-- =============================================

USE eMAG;
GO

CREATE VIEW dbo.vw_Sales
AS
SELECT
    o.OrderID,
    o.OrderDate,
    FORMAT(o.OrderDate, 'yyyy-MM')     AS YearMonth,
    YEAR(o.OrderDate)                  AS OrderYear,
    o.Status,
    c.FirstName + N' ' + c.LastName    AS CustomerName,
    c.City                             AS CustomerCity,
    p.ProductName,
    p.Brand,
    cat.CategoryName,
    s.SellerName,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice         AS SalesAmount
FROM Orders o
JOIN Customers  c   ON o.CustomerID  = c.CustomerID
JOIN OrderItems oi  ON o.OrderID     = oi.OrderID
JOIN Products   p   ON oi.ProductID  = p.ProductID
JOIN Categories cat ON p.CategoryID  = cat.CategoryID
JOIN Sellers    s   ON p.SellerID    = s.SellerID
WHERE o.Status <> N'Отказана';
GO

-- Проверка
SELECT * FROM dbo.vw_Sales;
