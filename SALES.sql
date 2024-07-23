CREATE  DATABASE SALES;
-- 1.create database
USE SALES;

/* The Project TITLE is "REAL-TIME SALES TRACKING SYSTEM" */
-- 2.Create table
CREATE TABLE Products (
product_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
price DECIMAL (20,2),
category VARCHAR(100),
pro_status ENUM ("Available","Unavailable","Upcoming_pro"));

CREATE TABLE Customers (
customer_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
gender ENUM ("Male","Female","Others"),
email VARCHAR (100) UNIQUE,
phone VARCHAR (15) UNIQUE,
city VARCHAR(100),
pin_code CHAR(6),
CHECK (pin_code REGEXP '^[0-9]{6}$'));


CREATE TABLE Sales (
sale_id INT PRIMARY KEY AUTO_INCREMENT,
product_id INT,
customer_id INT,
quantity INT,
sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (product_id) REFERENCES Products(product_id),
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE);

CREATE TABLE Inventory (
product_id INT PRIMARY KEY,
quantity INT,
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE);

CREATE INDEX idx_name
ON Customers (name,phone,pin_code) ;

-- 3.Insert Data;

INSERT INTO Products (product_id,name,price,category,pro_status) VALUES (1,"Laptop",40000,"Electronics","Available"),(2,"Phone",20000,"Electronics","Available"),(3,"Gas Stove",5000,"Kitchen Idem","Available"),
(4,"Cycling",10000,"Sports Hup","Available"),(5,"Football",1500,"Sports Hup","Available"),(6,"First Aid Kid",4000,"Medicines","Available");
SELECT * FROM products;
INSERT INTO Customers(customer_id,name,gender,email,phone,city,pin_code) VALUES (1,"Mariselvam ","Male", "mariselvam@gmail.com",786896578,"Melur",625108),
(2,"Nisanth ","Male", "nisanthnagarajan@gmail.com",9854673248,"Bodi",625513),
(3,"Hariharan ","Male", "chotta@gmail.com",6752849033,"Natham",624401),(4,"Maniraj ","Male", "mrking@gmail.com",6543889921,"Kallakurichi",606202),(5,"Arun","Male", "arunselvam@gmail.com",7435678786,"Melur",625109),
(6,"Saranya","Female", "sanya32@gmail.com",9492296578,"Karur",639114);
SELECT * FROM Customers;

INSERT INTO Inventory (product_id,quantity) VALUES (1,25),(2,23),(3,18),(4,25),(5,30),(6,35);

-- 4.create Triggers and Procedures
-- Trigger to update inventory affer a sale:
DELIMITER //

CREATE TRIGGER update_inventory_after_sale
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
  UPDATE Inventory
  SET quantity = quantity - NEW.quantity
  WHERE product_id = NEW.product_id;
  END ; // DELIMITER ;
  
   
INSERT INTO Sales (product_id,customer_id,quantity) VALUES (1,1,2);
INSERT INTO Sales (product_id,customer_id,quantity) VALUES(2,2,1);
SELECT * FROM Inventory WHERE product_id =2;

-- 5.Queries
SELECT * FROM Sales;

-- Find all sales for a specific customer:

SELECT Customers.customer_id,Sales.sale_id, Products.name, Sales.quantity, Sales.sale_date, Customers.name,Customers.pin_code
FROM Sales 
JOIN Products  ON Sales.product_id = Products.product_id
JOIN Customers ON Sales.customer_id = Customers.customer_id
WHERE Sales.customer_id=2
ORDER BY Sales.sale_id;

-- List all products with their current inventory levels:

SELECT p.name, i.quantity
FROM Products AS p
JOIN Inventory AS i ON p.product_id = i.product_id
;

-- 6.Real -Time Data Analysis
-- Find the most Sold Products:

SELECT p.name, SUM(s.quantity) AS total_sold
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC;

-- Track Inventory levels in real Time:
CREATE VIEW real_time_inventory 
AS
SELECT p.name,p.pro_status,i.quantity
FROM Products AS p JOIN Inventory AS i
ON p.product_id = i.product_id;

SELECT * FROM real_time_inventory;



-- Sales Summary report and revenue  :
SELECT p.category, COUNT(s.sale_id) AS total_sales, SUM(s.quantity) AS total_quantity, SUM(s.quantity * p.price) AS total_revenue
FROM Sales AS s
JOIN Products AS p ON s.product_id = p.product_id
GROUP BY p.category ;

SELECT * FROM Products ;
SELECT * FROM  Customers;

CREATE USER "SYSTEM"@"localhost" IDENTIFIED BY "mari@123";
GRANT ALL PRIVILEGES ON SALES.* TO "SYSTEM"@"localhost";