SELECT 
customers.customer_name,
orders.order_id,
SUM(orders.sales) AS hodnota
FROM customers
FULL OUTER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name, orders.order_id