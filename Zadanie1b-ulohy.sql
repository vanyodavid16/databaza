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
ORDER BY MONTH DESC

-- Uloha 6 --
SELECT product_category
FROM (SELECT product_category, SUM(total_amount) AS total_sales
FROM flourmills_sales
GROUP BY product_category
ORDER BY SUM(total_amount) DESC)
WHERE total_sales > 50000000


-- Uloha 7 --
SELECT t1.product_name,
t1.product_category, 
t1.total_amount
FROM flourmills_sales AS t1
WHERE t1.total_amount > (SELECT AVG(t2.total_amount)
FROM flourmills_sales AS t2
WHERE t1.product_category = t2.product_category)


-- Uloha 8 --
SELECT t1.product_name,
t1.region,
t1.total_amount,
( SELECT MIN(t2.total_amount)
FROM flourmills_sales AS t2
WHERE t1.region = t2.region
) AS region_min_amount
FROM flourmills_sales AS t1
ORDER BY t1.total_amount ASC


-- Uloha 9 --
SELECT t1.product_name
FROM flourmills_sales AS t1
WHERE EXISTS 
(SELECT 1
FROM flourmills_sales AS t2
WHERE t1.product_category = t2.product_category
GROUP BY t2.product_name
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM t2.sale_date)) > 1)

-- Uloha 10 --
SELECT t1.product_category, t1.product_name, t1.total_amount
FROM flourmills_sales AS t1
WHERE EXISTS ( SELECT 1 
FROM flourmills_sales AS t2
WHERE t1.product_category = t2.product_category
AND t2.total_amount > 200000)


-- Uloha 11 --
SELECT DISTINCT t1.product_category
FROM flourmills_sales AS t1
WHERE EXISTS ( SELECT 1
FROM flourmills_sales AS t2
WHERE t1.product_category = t2.product_category
HAVING COUNT(DISTINCT t2.region) > 3
)


-- Uloha 12 --
SELECT t1.*
FROM flourmills_sales AS t1
WHERE EXISTS ( SELECT 1
FROM flourmills_sales AS t2
WHERE t1.region = t2.region
AND EXTRACT(YEAR FROM t2.sale_date) = 2024
)

-- Uloha 13 --
SELECT t1.product_category
FROM flourmills_sales AS t1
WHERE NOT EXISTS ( SELECT 1
FROM flourmills_sales AS t2
WHERE t1.product_category = t2.product_category
AND t2.total_amount > 500000
)

-- Uloha 14 --
SELECT t1.region
FROM flourmills_sales AS t1
WHERE NOT EXISTS (SELECT 1
FROM flourmills_sales AS t2
WHERE t1.region = t2.region
AND t2.product_category = 'Flour'
)
