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
