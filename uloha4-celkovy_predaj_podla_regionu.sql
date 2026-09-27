SELECT customers.region , 
SUM(products.price * orderdetails.quantity) AS hodnota
FROM customers 
LEFT JOIN orders ON customers.customerid = orders.customerid
LEFT JOIN orderdetails ON orders.orderid = orderdetails.orderid
LEFT JOIN products ON orderdetails.productid = products.productid
GROUP BY customers.region