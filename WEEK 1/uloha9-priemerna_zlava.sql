SELECT products.category,
AVG(orders.discount) AS priemer
FROM products
JOIN orders ON products.product_id = orders.product_id
GROUP BY products.category
