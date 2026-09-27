SELECT customers.customername , 
COUNT(orders.orderid) AS pocet_objednavok
FROM customers 
LEFT JOIN orders ON customers.customerid = orders.customerid
GROUP BY customers.customername;