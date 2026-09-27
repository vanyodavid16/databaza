SELECT orders.order_id , 
customers.customer_name , 
SUM(products.products_price * orderdetails.quantity) AS hodnota  
FROM orders JOIN customers 
ON orders.customer_id = customers.customer_id
JOIN orderdetails
ON orders.orderid = orderdetails.orderid
JOIN products
ON orderdetails.productid = products.product_id
GROUP BY orders.orderid , customers.customerid
HAVING hodnota > 500 
ORDER BY hodnota DESC;