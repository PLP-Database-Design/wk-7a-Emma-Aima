/* Create and populate the initial ProductDetail table */

CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(100)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'), 
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

/* Question 1: Transform to 1NF
First, create a new table that will store the normalized data */
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100)
);

/* Insert the split data into the new normalized table */
INSERT INTO Product (OrderID, Product)
SELECT 
    OrderID,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) as Product
FROM 
    ProductDetail
    CROSS JOIN (
        SELECT 1 as n UNION ALL
        SELECT 2 UNION ALL
        SELECT 3
    ) numbers
WHERE 
    CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
    OR (
        CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) = 0 
        AND numbers.n = 1
    );

/* Question 2: Transform to 2NF
Create Orders table to store order-specific information */
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

/* Insert unique orders into the orders table */
INSERT INTO Orders (OrderID, CustomerName) 
SELECT DISTINCT OrderID, CustomerName
FROM ProductDetail;

INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

/* Products Table */
CREATE TABLE product(
    product_id INT primary key,
    productName varchar(100),
    quantity INT,
    order_id INT,
    FOREIGN KEY(order_id) references orders(OrderID)
);

INSERT INTO Product (product_id, productName, quanitity, order_id) VALUES
(1, 'Laptop', 2, 101),
(2, 'Mouse', 1, 101),
(3, 'Tablet', 3, 102),
(4, 'Keyboard', 1, 102),
(5, 'Mouse', 2, 102),
(6, 'Phone', 1, 103);

/* Now the tables are properly normalized:
Orders table contains order information (2NF)
Product table contains the products for each order (1NF)
The relationship between Orders and Products represents the complete normalized structure */
