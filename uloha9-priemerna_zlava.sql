SELECT categories.categoryname , 
AVG(orders.discount) AS zlava
FROM categories
JOIN product ON categories.categoryid = product.categoryid
JOIN orderdetails ON products.productid = orderdetails.productid
JOIN orders ON orderdetails.orderid = orders.orderid 
GROUP BY categories.categoryname
