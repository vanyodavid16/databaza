SELECT customers.region ,
SUM(products.price * orderdetails.quantity) AS hodnota
AVG(orders.dicosunt) as zlava
COUNT (DISTINCT orders.orderid) AS pocet
FROM customers
JOIN orders ON customers.customerid = orders.customerid
JOIN orderdetails ON orders.orderid = orderdetails.orderid
JOIN products ON orderdetails.productid = products.productid
GROUP BY customers.region ;
