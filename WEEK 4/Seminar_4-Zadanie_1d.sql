-- Active: 1790446499321@@127.0.0.1@5432@superstore
-- Uloha 1 -- pouzit databazu superstore
WITH ranked_orders AS(
    SELECT
    customers.customer_name,
    orders.product_id,
    orders.order_date,
    ROW_NUMBER() OVER(
        PARTITION BY orders.customer_id
        ORDER BY orders.order_date
    ) AS ro
FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
)
SELECT
customer_name,
product_id,
order_date
FROM ranked_orders
WHERE ro <= 2
ORDER BY customer_name , ro

-- Uloha 2 -- 
WITH customer_profit AS(
    SELECT
    customers.region,
    customers.customer_name,
    SUM(orders.profit) AS total_profit
    FROM orders
    JOIN customers ON customers.customer_id = orders.customer_id
    GROUP BY 
    customers.region,
    customers.customer_name,
    customers.customer_name
)
SELECT
region,
customer_name,
total_profit,
RANK() OVER(
    PARTITION BY region
    ORDER BY total_profit DESC
) AS profit_rank,
DENSE_RANK() OVER(
    PARTITION BY region
    ORDER BY total_profit DESC
) AS profit_dr
FROM customer_profit
ORDER BY region ASC, total_profit DESC

-- Uloha 3 --
WITH customer_sales AS (
    SELECT
        customers.customer_name,
        SUM(orders.sales) AS total_sales
    FROM orders 
    JOIN customers 
        ON orders.customer_id = customers.customer_id
    GROUP BY
        customers.customer_id,
        customers.customer_name
)
SELECT
    customer_name,
    total_sales,
    NTILE(4) OVER (
        ORDER BY total_sales DESC
    ) AS quartile
FROM customer_sales
ORDER BY total_sales DESC

-- Uloha 4 -- 
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (
        ORDER BY month
    ) AS prev_month_sales,
    LEAD(monthly_sales, 1) OVER (
        ORDER BY month
    ) AS next_month_sales
FROM monthly_sales
ORDER BY month ASC

-- Uloha 5 -- 
SELECT 
    p.category,
    p.product_name,
    SUM(o.sales) AS product_sales,
    SUM(SUM(o.sales)) OVER (
        PARTITION BY p.category) 
        AS category_total,
    ROUND(
        SUM(o.sales) * 100.0 /
        SUM(SUM(o.sales)) OVER (
            PARTITION BY p.category),
        2
    ) AS pct_of_category
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name;

WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.category,
        p.product_name
),
category_sales AS (
    SELECT
        category,
        product_name,
        product_sales,
        SUM(product_sales) OVER (
            PARTITION BY category
        ) AS category_total
    FROM product_sales
)
SELECT
    category,
    product_name,
    product_sales,
    category_total,
    ROUND(
        product_sales * 100.0 / NULLIF(category_total, 0),
        2
    ) AS pct_of_category
FROM category_sales
ORDER BY
    category ASC,
    pct_of_category DESC


    -- Uloha 6 -- 
    WITH customer_activity AS (
    SELECT
        orders.customer_id,
        customers.customer_name,
        MAX(orders.order_date) OVER (
            PARTITION BY orders.customer_id
        ) AS last_order_date,
        MAX(orders.order_date) OVER () AS latest_order_date
    FROM orders 
    JOIN customers 
        ON orders.customer_id = customers.customer_id
)
SELECT DISTINCT
    customer_id,
    customer_name,
    last_order_date
FROM customer_activity
WHERE last_order_date < latest_order_date - INTERVAL '90 days'
ORDER BY last_order_date ASC

-- Uloha 7 -- 
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
sales_with_lag AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY month
        ) AS prev_month_sales
    FROM monthly_sales
)
SELECT
    month,
    monthly_sales,
    prev_month_sales,
    monthly_sales - prev_month_sales AS sales_change,
    ROUND(
        (monthly_sales - prev_month_sales) * 100.0 /
        NULLIF(prev_month_sales, 0),
        2
    ) AS growth_percentage
FROM sales_with_lag
ORDER BY month ASC


-- Uloha 8 -- 
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS first_month
    FROM orders
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS returning_customers
FROM first_purchase fp
WHERE fp.first_month = DATE '2024-06-01'
AND EXISTS (
    SELECT 1
    FROM orders 
    WHERE orders.customer_id = fp.customer_id
      AND DATE_TRUNC('month', orders.order_date) > fp.first_month
)