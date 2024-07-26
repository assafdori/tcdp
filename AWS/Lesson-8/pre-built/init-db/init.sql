-- Database 1: Store_Info
CREATE DATABASE Store_Info;
USE Store_Info;

-- Table: Stores
CREATE TABLE Stores (
    StoreID INT AUTO_INCREMENT PRIMARY KEY,
    StoreName VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    StoreID INT,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Position VARCHAR(255) NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Table: Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    StoreID INT,
    ProductName VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Inserting Data into Stores
INSERT INTO Stores (StoreName, Location) VALUES
('Store A', 'Location 1'),
('Store B', 'Location 2'),
('Store C', 'Location 3');

-- Inserting Data into Employees
INSERT INTO Employees (StoreID, FirstName, LastName, Position) VALUES
(1, 'John', 'Doe', 'Manager'),
(1, 'Jane', 'Smith', 'Cashier'),
(1, 'Mike', 'Johnson', 'Sales Associate');

-- Inserting Data into Products
INSERT INTO Products (StoreID, ProductName, Price, Stock) VALUES
(1, 'Product 1', 10.99, 100),
(1, 'Product 2', 15.99, 200),
(1, 'Product 3', 5.99, 300);

-- Database 2: Sales_Data
CREATE DATABASE Sales_Data;
USE Sales_Data;

-- Table: Sales
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    StoreID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    SaleDate DATE NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Store_Info.Stores(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Store_Info.Products(ProductID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    SaleID INT,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(255) NOT NULL,
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

-- Inserting Data into Sales
INSERT INTO Sales (StoreID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 10, '2023-01-01'),
(1, 2, 5, '2023-01-02'),
(1, 3, 20, '2023-01-03');

-- Inserting Data into Customers
INSERT INTO Customers (FirstName, LastName, Email) VALUES
('Alice', 'Brown', 'alice@example.com'),
('Bob', 'White', 'bob@example.com'),
('Charlie', 'Black', 'charlie@example.com');

-- Inserting Data into Payments
INSERT INTO Payments (SaleID, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2023-01-01', 109.90, 'Credit Card'),
(2, '2023-01-02', 79.95, 'Cash'),
(3, '2023-01-03', 119.80, 'Credit Card');

-- Database 3: Inventory
CREATE DATABASE Inventory;
USE Inventory;

-- Table: InventoryLevels
CREATE TABLE InventoryLevels (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    StoreID INT,
    ProductID INT,
    StockLevel INT NOT NULL,
    LastUpdated DATE NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Store_Info.Stores(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Store_Info.Products(ProductID)
);

-- Table: Suppliers
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255) NOT NULL,
    ContactEmail VARCHAR(255) NOT NULL
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Store_Info.Products(ProductID)
);

-- Inserting Data into InventoryLevels
INSERT INTO InventoryLevels (StoreID, ProductID, StockLevel, LastUpdated) VALUES
(1, 1, 100, '2023-01-01'),
(1, 2, 200, '2023-01-02'),
(1, 3, 300, '2023-01-03');

-- Inserting Data into Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, ContactEmail) VALUES
('Supplier 1', 'Contact 1', 'contact1@example.com'),
('Supplier 2', 'Contact 2', 'contact2@example.com'),
('Supplier 3', 'Contact 3', 'contact3@example.com');

-- Inserting Data into Orders
INSERT INTO Orders (SupplierID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 50, '2023-01-01'),
(2, 2, 100, '2023-01-02'),
(3, 3, 150, '2023-01-03');
