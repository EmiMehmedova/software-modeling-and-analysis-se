-- =============================================
-- eMAG - Създаване на базата данни и таблиците
-- =============================================

CREATE DATABASE eMAG;
GO

USE eMAG;
GO

-- 1. Категории
CREATE TABLE Categories (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);

-- 2. Продавачи
CREATE TABLE Sellers (
    SellerID   INT IDENTITY(1,1) PRIMARY KEY,
    SellerName NVARCHAR(100) NOT NULL,
    City       NVARCHAR(50)
);

-- 3. Клиенти
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    LastName   NVARCHAR(50) NOT NULL,
    Email      NVARCHAR(100) NOT NULL UNIQUE,
    Phone      NVARCHAR(20),
    City       NVARCHAR(50)
);

-- 4. Продукти
CREATE TABLE Products (
    ProductID   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    Brand       NVARCHAR(50),
    Price       DECIMAL(10,2) NOT NULL,
    CategoryID  INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    SellerID    INT NOT NULL FOREIGN KEY REFERENCES Sellers(SellerID)
);

-- 5. Поръчки
CREATE TABLE Orders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate   DATE NOT NULL,
    Status      NVARCHAR(30) NOT NULL,
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    CustomerID  INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID)
);

-- 6. Продукти в поръчка (връзка много към много)
CREATE TABLE OrderItems (
    OrderID   INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity  INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);

-- 7. Ревюта
CREATE TABLE Reviews (
    ReviewID   INT IDENTITY(1,1) PRIMARY KEY,
    Rating     INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment    NVARCHAR(500),
    ProductID  INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID)
);
GO
