SELECT customers.customer_name,
SUM(orders.sales) AS hodnota
AVG(orders.discount) AS priemer
COUNT(DISTINCT orders.order_id) AS pocet
CASE WHEN SUM(orders.sales) > 2500 THEN 'VIP'
ELSE 'REGULAR' END AS typ_zakaznika
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name
ORDER BY SUM(orders.sales) DESC