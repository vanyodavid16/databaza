CREATE TABLE customers (
    customerid INT(20) PRIMARY KEY,
    customername VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE products(
    productid INT(20) PRIMARY KEY,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    productname VARCHAR(100),
);

CREATE TABLE orders(
    orderid INT(20) PRIMARY KEY,
    customerid VARCHAR(20),
    productid VARCHAR(20),
    orderdate DATE,
    shipdate DATE,
    sales DECIMAL(10,2),
    discount DECIMAL(5,2),
    quality INT,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (customerid) REFERENCES customers(customerid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);