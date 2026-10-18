-- Active: 1790446499321@@127.0.0.1@5432@retail@public
CREATE DATABASE retail

CREATE TABLE retail_sales(
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price DECIMAL(10,2),
    customer_id INT,
    country VARCHAR(100)
)

SELECT * FROM retail_sales
