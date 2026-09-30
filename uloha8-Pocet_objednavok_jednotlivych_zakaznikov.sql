SELECT customers.customer_name,
COUNT(orders.order_id) AS pocet_objednavok
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name