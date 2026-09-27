SELECT customers.customername ,
SUM(products.price * orderdetails.quantity) AS hodnota 
AVG(orders.disount) AS zlava
COUNT (DISCTINCT orders.orderid) AS pocet
CASE 
WHEN SUM(products.price * orderdetails.quantity) > 2500 THEN 'VIP'
ELSE 'Standard' END AS typzakaznika
FROM customers
JOIN orders ON customers.customerid = orders.customerid
JOIN orderdetails ON orders.orderid = orderdetails.orderid
GROUP BY customers.customername
ORDER BY hodnota DESC;