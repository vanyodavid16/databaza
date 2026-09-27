SELECT customers.customername ,
orders.orderid
SUM(products.price * orderdetails.quantity) AS hodnota
FROM customers 
FULL OUTER JOIN orders
ON customer.custoerid = orders.customerid 
LEFT JOIN orderdetails
ON orders.orderid = orderdetails.orderid
LEFT JOIN products
ON orderdetails.productid = products.productid
GROUP BY customers.customername , orders.orderid;