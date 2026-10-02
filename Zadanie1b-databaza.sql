-- Active: 1790446499321@@127.0.0.1@5432@datacraftinglab_db@public
-- Active: 1790446499321@@127.0.0.1@5432@datacraftinglab_db-- Active: 1790446499321@@127.0.0.1@5432@postgres@public
CREATE DATABASE datacraftinglab_db;

USE datacraftinglab_db;

CREATE TABLE flourmills_sales
(
sales_id INTEGER PRIMARY KEY,
sale_date DATE,
region VARCHAR(100),
state VARCHAR(100),
product_category VARCHAR(100),
product_name VARCHAR(150),
customer_type VARCHAR(100),
customer_id INTEGER,
quantity_sold INTEGER,
unit_price DECIMAL(10, 2),
discount_rate INTEGER,
payment_method VARCHAR(50),
sales_rep VARCHAR(150),
warehouse VARCHAR(100),
delivery_status VARCHAR(100),
order_channel VARCHAR(100),
batch_number INTEGER,
producction_date DATE,
total_amount DECIMAL(10, 2)
)