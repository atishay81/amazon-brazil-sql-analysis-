-- Amazon India Data Analysis SQL Queries
-- =====================================

-- ANALYSIS - I
-- ============

-- Query 1: Standardize Payment Values
-- Question: To simplify its financial reports, Amazon India needs to standardize payment values. 
-- Round the average payment values to integer (no decimal) for each payment type and display 
-- the results sorted in ascending order.
-- Output: payment_type, rounded_avg_payment

SELECT payment_type, ROUND(AVG(payment_value)) AS rounded_avg_payment
FROM payments
GROUP BY payment_type
ORDER BY rounded_avg_payment ASC;

-- Query 2: Payment Type Distribution
-- Question: To refine its payment strategy, Amazon India wants to know the distribution of orders 
-- by payment type. Calculate the percentage of total orders for each payment type, rounded to 
-- one decimal place, and display them in descending order.
-- Output: payment_type, percentage_orders

SELECT payment_type,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage_orders
FROM payments
GROUP BY payment_type
ORDER BY percentage_orders DESC;

-- Query 3: Smart Products in Price Range
-- Question: Amazon India seeks to create targeted promotions for products within specific price ranges. 
-- Identify all products priced between 100 and 500 BRL that contain the word 'Smart' in their name. 
-- Display these products, sorted by price in descending order.
-- Output: product_id, price

SELECT o.product_id, o.price
FROM order_items AS o
JOIN products AS p
ON o.product_id = p.product_id
WHERE o.price BETWEEN 100 AND 500 AND p.product_category_name LIKE '%smart%'
ORDER BY o.price DESC;

-- Query 4: Top 3 Sales Months
-- Question: To identify seasonal sales patterns, Amazon India needs to focus on the most successful months. 
-- Determine the top 3 months with the highest total sales value, rounded to the nearest integer.
-- Output: month, total_sales

SELECT TO_CHAR(o.order_purchase_timestamp, 'Month') AS month,
ROUND(SUM(oi.price)) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'Month')
ORDER BY total_sales DESC
LIMIT 3;

-- Query 5: Categories with High Price Variations
-- Question: Amazon India is interested in product categories with significant price variations. 
-- Find categories where the difference between the maximum and minimum product prices is greater than 500 BRL.
-- Output: product_category_name, price_difference

SELECT p.product_category_name,
(MAX(o.price) - MIN(o.price)) AS price_difference
FROM products p
JOIN order_items o
ON p.product_id = o.product_id
GROUP BY p.product_category_name
HAVING (MAX(o.price) - MIN(o.price)) > 500;

-- Query 6: Payment Type Consistency Analysis
-- Question: To enhance the customer experience, Amazon India wants to find which payment types 
-- have the most consistent transaction amounts. Identify the payment types with the least variance 
-- in transaction amounts, sorting by the smallest standard deviation first.
-- Output: payment_type, std_deviation

SELECT payment_type,
STDDEV(payment_value) AS std_deviation
FROM payments
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY std_deviation ASC;

-- Query 7: Products with Incomplete Category Names
-- Question: Amazon India wants to identify products that may have incomplete name in order to 
-- fix it from their end. Retrieve the list of products where the product category name is 
-- missing or contains only a single character.
-- Output: product_id, product_category_name

SELECT product_id, product_category_name
FROM products
WHERE product_category_name IS NULL
OR TRIM(product_category_name) LIKE '_';

-- ANALYSIS - II
-- =============

-- Query 8: Payment Type Popularity Across Order Value Segments
-- Question: Amazon India wants to understand which payment types are most popular across different 
-- order value segments (e.g., low, medium, high). Segment order values into three ranges: orders 
-- less than 200 BRL, between 200 and 1000 BRL, and over 1000 BRL. Calculate the count of each 
-- payment type within these ranges and display the results in descending order of count.
-- Output: order_value_segment, payment_type, count

SELECT
CASE WHEN payment_value < 200 THEN 'Low'
     WHEN payment_value BETWEEN 200 AND 1000 THEN 'Medium'
     WHEN payment_value > 1000 THEN 'High'
END AS order_value_segment,
payment_type,
COUNT(*) AS count
FROM payments
GROUP BY payment_type, order_value_segment
ORDER BY count DESC;

-- Query 9: Product Category Price Analysis
-- Question: Amazon India wants to analyse the price range and average price for each product category. 
-- Calculate the minimum, maximum, and average price for each category, and list them in descending 
-- order by the average price.
-- Output: product_category_name, min_price, max_price, avg_price

SELECT p.product_category_name,
MIN(o.price) AS min_price,
MAX(o.price) AS max_price,
ROUND(AVG(o.price)::NUMERIC, 2) AS avg_price
FROM products p
JOIN order_items o
ON p.product_id = o.product_id
GROUP BY product_category_name
ORDER BY avg_price DESC;

-- Query 10: Multi-Order Customers
-- Question: Amazon India wants to identify the customers who have placed multiple orders over time. 
-- Find all customers with more than one order, and display their customer unique IDs along with 
-- the total number of orders they have placed.
-- Output: customer_unique_id, total_orders

SELECT c.customer_unique_id,
COUNT(o.order_purchase_timestamp) AS total_orders
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Query 11: Customer Categorization
-- Question: Amazon India wants to categorize customers into different types ('New' – order qty. = 1; 
-- 'Returning' – order qty. 2 to 4; 'Loyal' – order qty. >4) based on their purchase history. 
-- Use a temporary table to define these categories and join it with the customers table to 
-- update and display the customer types.
-- Output: customer_unique_id, customer_type

SELECT c.customer_unique_id,
CASE
    WHEN COUNT(o.order_purchase_timestamp) = 1 THEN 'New'
    WHEN COUNT(o.order_purchase_timestamp) BETWEEN 2 AND 4 THEN 'Returning'
    WHEN COUNT(o.order_purchase_timestamp) > 4 THEN 'Loyal'
END AS customer_type
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id;

-- Query 12: Top Revenue Generating Categories
-- Question: Amazon India wants to know which product categories generate the most revenue. 
-- Use joins between the tables to calculate the total revenue for each product category. 
-- Display the top 5 categories.
-- Output: product_category_name, total_revenue

SELECT p.product_category_name,
ROUND(SUM(price)::NUMERIC, 2) AS total_revenue
FROM products p
JOIN order_items o
ON p.product_id = o.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- ANALYSIS - III
-- ==============

-- Query 13: Seasonal Sales Comparison
-- Question: The marketing team wants to compare the total sales between different seasons. 
-- Use a subquery to calculate total sales for each season (Spring, Summer, Autumn, Winter) 
-- based on order purchase dates, and display the results. Spring is in the months of March, 
-- April and May. Summer is from June to August and Autumn is between September and November 
-- and rest months are Winter.
-- Output: season, total_sales

SELECT
season,
ROUND(SUM(total_price)::NUMERIC, 2) AS total_sales
FROM (
    SELECT
    CASE
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (9, 10, 11) THEN 'Autumn'
        ELSE 'Winter'
    END AS season,
    oi.price AS total_price
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
) AS seasonal_sales
GROUP BY season
ORDER BY total_sales DESC;

-- Query 14: Above-Average Sales Volume Products
-- Question: The inventory team is interested in identifying products that have sales volumes 
-- above the overall average. Write a query that uses a subquery to filter products with a 
-- total quantity sold above the average quantity.
-- Output: product_id, total_quantity_sold

SELECT
product_id,
COUNT(order_id) AS total_quantity_sold
FROM order_items
GROUP BY product_id
HAVING COUNT(order_id) > (
    SELECT AVG(product_order_count)
    FROM (SELECT COUNT(order_id) AS product_order_count
          FROM order_items
          GROUP BY product_id
    )
)
ORDER BY total_quantity_sold DESC;

-- Query 15: Monthly Revenue Trends for 2018
-- Question: To understand seasonal sales patterns, the finance team is analysing the monthly 
-- revenue trends over the past year (year 2018). Run a query to calculate total revenue 
-- generated each month and identify periods of peak and low sales. Export the data to Excel 
-- and create a graph to visually represent revenue changes across the months.
-- Output: month, total_revenue

SELECT EXTRACT(month FROM o.order_purchase_timestamp) AS month,
ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE EXTRACT(year FROM o.order_purchase_timestamp) = 2018
GROUP BY month
ORDER BY month ASC;

-- Query 16: Customer Segmentation Using CTE
-- Question: A loyalty program is being designed for Amazon India. Create a segmentation based 
-- on purchase frequency: 'Occasional' for customers with 1-2 orders, 'Regular' for 3-5 orders, 
-- and 'Loyal' for more than 5 orders. Use a CTE to classify customers and their count and 
-- generate a chart in Excel to show the proportion of each segment.
-- Output: customer_type, count

WITH customerCTE AS (
SELECT
CASE WHEN COUNT(order_id) BETWEEN 1 AND 2 THEN 'Occasional'
     WHEN COUNT(order_id) BETWEEN 3 AND 5 THEN 'Regular'
     WHEN COUNT(order_id) > 5 THEN 'Loyal'
END AS customer_type
FROM orders
GROUP BY customer_id
)
SELECT customer_type, COUNT(*) AS count
FROM customerCTE
GROUP BY customer_type;

-- Query 17: Top 20 High-Value Customers
-- Question: Amazon wants to identify high-value customers to target for an exclusive rewards program. 
-- You are required to rank customers based on their average order value (avg_order_value) to 
-- find the top 20 customers.
-- Output: customer_id, avg_order_value, and customer_rank

WITH rankedCustomer AS (
SELECT o.customer_id,
ROUND(AVG(oi.price)::numeric, 2) AS avg_order_value,
DENSE_RANK() OVER (ORDER BY AVG(oi.price) DESC) AS customer_rank
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.customer_id
)
SELECT * FROM rankedCustomer
WHERE customer_rank <= 20;

-- Query 18: Monthly Cumulative Sales Using Recursive CTE
-- Question: Amazon wants to analyze sales growth trends for its key products over their lifecycle. 
-- Calculate monthly cumulative sales for each product from the date of its first sale. Use a 
-- recursive CTE to compute the cumulative sales (total_sales) for each product month by month.
-- Output: product_id, sale_month, and total_sales

WITH RECURSIVE monthly_sales AS (
SELECT oi.product_id,
DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS sale_month,
SUM(oi.price) AS monthly_sales
FROM order_items oi JOIN orders o ON oi.order_id = o.order_id
WHERE DATE_PART('year', o.order_purchase_timestamp) = 2018
GROUP BY oi.product_id, sale_month
), cte_base AS (
SELECT ms.product_id, ms.sale_month, ms.monthly_sales, ms.monthly_sales AS total_sales
FROM monthly_sales ms
WHERE ms.sale_month = (SELECT MIN(s.sale_month)
FROM monthly_sales s
WHERE s.product_id = ms.product_id) UNION ALL
SELECT rs.product_id, ms.sale_month, ms.monthly_sales,
rs.total_sales + ms.monthly_sales AS total_sales
FROM cte_base rs JOIN monthly_sales ms ON rs.product_id = ms.product_id
AND ms.sale_month = rs.sale_month + INTERVAL '1 month')
SELECT
product_id,
sale_month,
ROUND(total_sales::NUMERIC, 2) AS total_sales
FROM cte_base
ORDER BY product_id, sale_month;

-- Query 19: Month-over-Month Growth Rate Analysis
-- Question: To understand how different payment methods affect monthly sales growth, Amazon wants 
-- to compute the total sales for each payment method and calculate the month-over-month growth 
-- rate for the past year (year 2018). Write query to first calculate total monthly sales for 
-- each payment method, then compute the percentage change from the previous month.
-- Output: payment_type, sale_month, monthly_total, monthly_change

WITH monthly_sales AS (
SELECT p.payment_type,
DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS sale_month,
SUM(p.payment_value) AS monthly_total
FROM payments p JOIN orders o ON p.order_id = o.order_id
WHERE DATE_PART('year', o.order_purchase_timestamp) = 2018
GROUP BY p.payment_type, sale_month
), monthly_with_change AS (
SELECT payment_type, sale_month,
ROUND(monthly_total::NUMERIC, 2) AS monthly_total,
ROUND(((monthly_total - LAG(monthly_total) OVER
(PARTITION BY payment_type ORDER BY sale_month)) / NULLIF(LAG(monthly_total) OVER
(PARTITION BY payment_type ORDER BY sale_month), 0))::NUMERIC, 4) * 100 AS monthly_change
FROM monthly_sales
)
SELECT
payment_type,
sale_month,
monthly_total,
ROUND(monthly_change, 2) AS monthly_change
FROM monthly_with_change
ORDER BY payment_type, sale_month;

-- =============================================================================
-- SUMMARY OF QUERIES:
-- Total: 19 comprehensive SQL queries covering all Amazon India analysis requirements
-- =============================================================================