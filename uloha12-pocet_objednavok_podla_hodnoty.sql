SELECT customers.region , 
SUM( CASE WHEN ordervalue > 1000 THEN 1 ELSE 0 end) AS highvalue ,
SUM( CASE WHEN ordervalue <= 1000 THEN 1 ELSE 0 end) AS lowvalue 
FROM customers
JOIN orders ON customers.customerid = orders.customerid
(SELECT orderdetails.orderid, 
SUM(products.price * orderdetails.quantity) AS ordervalue
FROM orderdetails
JOIN products ON orderdetails.productid = products.productid
GROUP BY orderdetails.orderid
) AS ordertotal
ON orders.orderid = ordertotal.orderid
GROUP BY customers.region ;