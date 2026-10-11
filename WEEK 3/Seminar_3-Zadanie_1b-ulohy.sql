-- Active: 1790446499321@@127.0.0.1@5432@datacraftinglab_db
-- Uloha 1 --
WITH daily_sales AS (
    SELECT sale_date, SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date 
    ORDER BY SUM(total_amount) DESC
) 
SELECT * FROM daily_sales
WHERE total_daily_sales > 3000000

-- Uloha 2 --
WITH category_sales AS(
    SELECT product_category, SUM(total_amount) AS total_category_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT * FROM category_sales

-- Uloha 3 --
WITH total_product_sales AS (
SELECT
product_category,
product_name,
SUM(total_amount) AS total_sales
FROM flourmills_sales
GROUP BY product_category, product_name
),
ranked_products AS (
SELECT
product_category,
product_name,
total_sales,
RANK() OVER (
PARTITION BY product_category
ORDER BY total_sales DESC
) AS category_rank
FROM total_product_sales
)
SELECT *
FROM ranked_products
WHERE category_rank BETWEEN 1 AND 3
ORDER BY product_category, category_rank


-- Uloha 4 --
WITH customer_revenue AS (
    SELECT customer_type, SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_percentage AS (
    SELECT customer_type, revenue,
    SUM(revenue) OVER() AS total_revenue,
    ROUND(revenue * 100 / SUM(revenue)OVER(),2) AS revenue_percentage
    FROM customer_revenue
)
SELECT customer_type,revenue,total_revenue,revenue_percentage
FROM revenue_percentage 
ORDER BY revenue DESC

-- Uloha 5 -- 
WITH transaction AS(
    SELECT customer_id,
    product_name,
    sale_date,
    total_amount,
    ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY sale_date DESC
    ) AS row_num
    FROM flourmills_sales
)
SELECT customer_id,product_name,sale_date,total_amount
FROM transaction
order by customer_id ASC

-- Uloha 6 -- 
WITH RECURSIVE date_bounds AS (
    SELECT 
    MIN(sale_date) AS min_date,
    MAX(sale_date) AS max_date
    FROM flourmills_sales
),
calendar_dates AS (
    SELECT min_date AS sale_date
    FROM date_bounds

    UNION ALL 

    SELECT sale_date + 1
    FROM calendar_dates,date_bounds
    WHERE sale_date < max_date
)
SELECT sale_date 
FROM calendar_dates
ORDER BY sale_date ASC


-- Uloha 7 --
WITH RECURSIVE monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sale_date)::date AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
ordered_months AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT
        next.rn,
        next.month,
        next.revenue,
        current.cumulative_revenue + next.revenue
            AS cumulative_revenue
    FROM cumulative_target AS current
    JOIN ordered_months AS next
        ON next.rn = current.rn + 1
    WHERE current.cumulative_revenue < 500000000
)
SELECT
rn,
month,
revenue,
cumulative_revenue
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;