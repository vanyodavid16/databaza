-- Active: 1790446499321@@127.0.0.1@5432@retail_sales@public
-- pouzit tabulku superstore --
-- uloha 1 --
CREATE VIEW high_value_customers AS
SELECT customers.customer_id, customers.customer_name, 
SUM(orders.sales) AS total_sales
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id
HAVING SUM(orders.sales) > 2000

SELECT * FROM high_value_customers;

-- uloha 2 --
CREATE VIEW regional_monthly_sales AS
SELECT customers.region, 
DATE_TRUNC('month', orders.order_date) AS month, SUM(orders.sales) AS monthly_sales
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.region, DATE_TRUNC('month', orders.order_date)

SELECT * FROM regional_monthly_sales;

-- uloha 3 --
CREATE VIEW analyst_orders AS 
SELECT order_id, 
customer_id, 
product_id, 
sales, 
quality, 
discount
FROM orders

SELECT * FROM analyst_orders;

-- uloha 4 --
CREATE INDEX idx_orders_customer_id
ON orders(customer_id)

SELECT * FROM orders
WHERE customer_id = 'C001'


-- uloha 5 --
CREATE INDEX idx_orders_order_date
ON orders(order_date)

SELECT DATE_TRUNC('month', order_date) AS month, 
SUM(sales) AS monthly_sales
FROM orders
GROUP BY DATE_TRUNC('month', order_date)

-- uloha 6 --
CREATE INDEX idx_orders_region_category 
ON orders ( customer_id, order_date)

SELECT * FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE customers.region = 'West' 
AND orders.order_date >= '2023-01-01'


-- uloha 7 --
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 'C001'

-- vytvorenie novej databazy --
-- iný priečinok --

-- od tadeto použit tabulku retail_sales)
-- uloha 8 --
CREATE PROCEDURE get_customer_sales(
    p_customer_id VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(10, 2);
BEGIN
SELECT COALESCE(SUM(sales), 0)
INTO v_total_sales
FROM orders
WHERE customer_id = p_customer_id;

RAISE NOTICE 'Customer ID: %, Total sales: %',
    p_customer_id, v_total_sales;
END;
$$;

-- uloha 9 --
CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR(20),
    discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $procedure$
BEGIN
UPDATE orders
SET sales = sales * (1 - discount_rate)
FROM customers
WHERE orders.customer_id = customers.customer_id
AND customers.region = region_name;

RAISE NOTICE 'Discount of % applied to region %',
    discount_rate * 100, region_name;
END;
$procedure$;

-- uloha 10 --
CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(10, 2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Period: % to %, Total sales: %',
        start_date, end_date, v_total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');