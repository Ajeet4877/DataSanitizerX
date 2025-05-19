-- Create the main sales data table
CREATE TABLE sales_data (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INTEGER,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10, 2),
    CustomerID INTEGER,
    Country VARCHAR(100)
);

-- 1. Display the first 10 rows of the table
SELECT * FROM sales_data
LIMIT 10;

-- 2. Display the first 7 rows as a sample
SELECT * FROM sales_data
LIMIT 7;

-- 3. Select all records where the country is Germany
SELECT * FROM sales_data
WHERE Country = 'Germany';

-- 4. Show the top 7 most expensive products by UnitPrice
SELECT Description, UnitPrice
FROM sales_data
ORDER BY UnitPrice DESC
LIMIT 7;

-- 5. Calculate total revenue per country
SELECT Country, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM sales_data
GROUP BY Country
ORDER BY TotalRevenue DESC;

-- 6. Find the top 10 best-selling products based on total quantity sold
SELECT Description, SUM(Quantity) AS TotalSold
FROM sales_data
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;

-- 7. Find customers whose total spend is above the average customer spend
SELECT DISTINCT CustomerID
FROM sales_data
GROUP BY CustomerID
HAVING SUM(Quantity * UnitPrice) > (
    SELECT AVG(total)
    FROM (
        SELECT CustomerID, SUM(Quantity * UnitPrice) AS total
        FROM sales_data
        GROUP BY CustomerID
    ) AS avg_table
);

-- 8. Create a view showing total revenue per product
CREATE VIEW product_revenue AS
SELECT Description, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM sales_data
GROUP BY Description;

-- 9. Perform INNER JOIN to link invoices with descriptions (self join)
SELECT a.InvoiceNo, a.CustomerID, a.Country, b.Description
FROM sales_data a
INNER JOIN sales_data b ON a.InvoiceNo = b.InvoiceNo
WHERE a.CustomerID IS NOT NULL;

-- 10. Simulate LEFT JOIN: list customers and their invoices (if any)
WITH customers AS (
    SELECT DISTINCT CustomerID, Country
    FROM sales_data
)
SELECT c.CustomerID, s.InvoiceNo
FROM customers c
LEFT JOIN sales_data s ON c.CustomerID = s.CustomerID;

-- 11. Simulate RIGHT JOIN by using LEFT JOIN from invoice perspective
WITH invoices AS (
    SELECT DISTINCT InvoiceNo, CustomerID
    FROM sales_data
)
SELECT s.InvoiceNo, c.CustomerID
FROM invoices s
LEFT JOIN (
    SELECT DISTINCT CustomerID
    FROM sales_data
) c ON s.CustomerID = c.CustomerID;

-- 12. Show monthly revenue trend using DATE_TRUNC on InvoiceDate
SELECT DATE_TRUNC('month', InvoiceDate) AS Month, 
       SUM(Quantity * UnitPrice) AS Revenue
FROM sales_data
GROUP BY Month
ORDER BY Month;

-- 13. Create an index on CustomerID to optimize customer-based queries
CREATE INDEX idx_customer_id ON sales_data(CustomerID);

-- 14. Create an index on InvoiceDate to optimize date-based queries
CREATE INDEX idx_invoice_date ON sales_data(InvoiceDate);
