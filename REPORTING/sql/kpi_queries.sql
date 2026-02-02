USE reporting_project;

-- KPI: Total Revenue
-- Calculates the total revenue generated across all transactions
SELECT
    SUM(ti.total_amount) AS total_revenue
FROM transaction_items ti;

-- KPI: Total Transactions
-- Counts the total number of unique transactions
SELECT
    COUNT(t.transaction_id) AS total_transactions
FROM transactions t;

-- KPI: Average Order Value (AOV)
-- Calculates the average revenue per transaction
SELECT
    AVG(order_total) AS average_order_value
FROM (
    SELECT
        ti.transaction_id,
        SUM(ti.total_amount) AS order_total
    FROM transaction_items ti
    GROUP BY ti.transaction_id
) order_totals;

-- KPI: Min and Max Order Value
-- Identifies the smallest and largest transaction totals
SELECT
    MIN(order_total) AS min_order_value,
    MAX(order_total) AS max_order_value
FROM (
    SELECT
        ti.transaction_id,
        SUM(ti.total_amount) AS order_total
    FROM transaction_items ti
    GROUP BY ti.transaction_id
) order_totals;

-- KPI: Revenue per Day
-- Calculates total revenue generated for each calendar day
SELECT
    t.date AS transaction_date,
    SUM(ti.total_amount) AS daily_revenue
FROM transactions t
JOIN transaction_items ti
    ON t.transaction_id = ti.transaction_id
GROUP BY t.date
ORDER BY t.date;

-- KPI: Transactions per Day
-- Counts the number of transactions occurring each day
SELECT
    t.date AS transaction_date,
    COUNT(t.transaction_id) AS daily_transactions
FROM transactions t
GROUP BY t.date
ORDER BY t.date;

-- KPI: Revenue by Category
-- Calculates total revenue generated for each product category
SELECT
    c.category_name AS product_category,
    SUM(ti.total_amount) AS category_revenue
FROM transaction_items ti
JOIN products p
    ON ti.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;

-- KPI: Units Sold by Category
-- Calculates the total number of units sold for each product category
SELECT
    c.category_name AS product_category,
    SUM(ti.quantity) AS units_sold
FROM transaction_items ti
JOIN products p
    ON ti.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY units_sold DESC;


