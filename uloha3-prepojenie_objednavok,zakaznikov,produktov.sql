SELECT orders.orderid , 
customers.contactname , 
categories.categoryname , 
products.price * orderdetails.quantity AS hodnota
FROM orders 
JOIN customers ON orders.customerid = customers.customerid
JOIN orderdetails ON orders.orderid = orderdetails.orderid
JOIN products ON orderdetails.productid = products.productid
JOIN categories ON products.categoryid = categories.categoryid
