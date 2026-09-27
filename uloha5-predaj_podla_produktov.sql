SELECT products.productname , 
SUM(products.price * orderdetails.quantity) AS hodnota 
FROM products
LEFT JOIN orderdetails ON products.productid = orderdetails.productid
GROUP BY products.productname
