-- Uloha 1 --
SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);

-- Uloha 2 --
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id;

-- Uloha 3 --
SELECT product_name, total_amount,
(SELECT AVG(total_amount) FROM flourmills_sales
) AS priemer
FROM flourmills_sales


-- Uloha 4 --
SELECT product_name, total_amount,
total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales


-- Uloha 5 --
SELECT month,monthly_sales
FROM 
(SELECT
EXTRACT(MONTH FROM sale_date) AS month,
SUM(total_amount) AS monthly_sales
FROM flourmills_sales
GROUP BY EXTRACT(MONTH FROM sale_date)) AS mesiac
ORDER BY MONTH DESC;

-- Uloha 6 --
SELECT product_category
FROM (SELECT product_category, SUM(total_amount) AS total_sales
FROM flourmills_sales
GROUP BY product_category
ORDER BY SUM(total_amount) DESC)
WHERE total_sales > 50000000