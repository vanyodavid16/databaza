SELECT customers.customer_name,
SUM(orders.sales) AS hodnota
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name
HAVING SUM(orders.sales) > 2000;