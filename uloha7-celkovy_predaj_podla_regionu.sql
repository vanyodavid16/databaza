SELECT customers.region, 
SUM(orders.sales) AS hodnota
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.region