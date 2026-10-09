SELECT customers.region,
SUM(orders.sales) AS hodnota
AVG(orders.discount) AS priemer
COUNT(DISTINCT orders.order_id) AS pocet
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.region