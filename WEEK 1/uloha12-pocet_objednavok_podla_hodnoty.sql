SELECT customers.region,
SUM( CASE WHEN orders.sales > 1000 THEN 1 ELSE 0 END ) AS high_value
SUM( CASE WHEN orders.sales <=1000 THEN 1 ELSE 0 END ) AS low_value
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.region