CREATE DATABASE reporting_project;
USE reporting_project;
SELECT * FROM retail_dataset;

# NORMALIZATION: Table creation 

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    gender ENUM('Male', 'Female'),
    age INT
);
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    price_per_unit DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    date DATE,
    customer_id VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transaction_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

#Table population 
INSERT INTO customers (customer_id, gender, age)
SELECT DISTINCT customer_id, gender, age
FROM retail_dataset;

INSERT INTO categories (category_name)
SELECT DISTINCT product_category
FROM retail_dataset;

INSERT INTO products (category_id, price_per_unit)
SELECT DISTINCT c.category_id, s.price_per_unit
FROM  retail_dataset s
JOIN categories c
    ON s.product_category = c.category_name;
    
INSERT INTO transactions (transaction_id, date, customer_id)
SELECT DISTINCT transaction_id, date, customer_id
FROM retail_dataset;

INSERT INTO transaction_items (transaction_id, product_id, quantity, total_amount)
SELECT
    s.transaction_id,
    p.product_id,
    s.quantity,
    s.total_amount
FROM retail_dataset s
JOIN categories c
    ON s.product_category = c.category_name
JOIN products p
    ON p.category_id = c.category_id
   AND p.price_per_unit = s.price_per_unit;








