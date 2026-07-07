/*Segment products into cost ranges and count how many products fall into each segment*/
SELECT 
product_key,
product_name,
cost 
FROM dim_products

-- Creating new categories
SELECT 
product_key,
product_name,
cost,
CASE WHEN cost< 100 THEN 'Below 100' 
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'Above 1000'
END cost_range
FROM dim_products

--Aggregating the products based on the new categories
WITH product_segments as
(
    SELECT 
product_key,
product_name,
cost,
CASE WHEN cost< 100 THEN 'Below 100' 
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'Above 1000'
END cost_range
FROM dim_products
)
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behavior:
-VIP: Customers with at least 12 months of history and spending more than $5,000.
-Regular: Customers with at least 12 months of history but spending $5,000 or less.
-New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

--Customer details
SELECT
c.customer_key,
s.sales_amount,
s.order_date
FROM fact_sales as s
LEFT JOIN dim_customers as c
ON s.customer_key = c.customer_key

--Customer Lifespan
SELECT
c.customer_key,
SUM(s.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) * 12 +
EXTRACT(MONTH FROM AGE(MAX(order_date),MIN(order_date))) as lifespan
FROM fact_sales as s
LEFT JOIN dim_customers as c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key

--Segmenting the customers based on spending and lifespan
WITH customer_spending AS
(
    SELECT
c.customer_key,
SUM(s.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) * 12 +
EXTRACT(MONTH FROM AGE(MAX(order_date),MIN(order_date))) as lifespan
FROM fact_sales as s
LEFT JOIN dim_customers as c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key

)

SELECT 
customer_key,
total_spending,
lifespan,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
     ELSE 'New'
END customer_segment
FROM customer_spending

--Total number of customers per segment
WITH customer_spending AS
(
    SELECT
c.customer_key,
SUM(s.sales_amount) as total_spending,
MIN(order_date) as first_order,
MAX(order_date) as last_order,
EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) * 12 +
EXTRACT(MONTH FROM AGE(MAX(order_date),MIN(order_date))) as lifespan
FROM fact_sales as s
LEFT JOIN dim_customers as c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key

)
SELECT
customer_segment,
COUNT(customer_key) as total_customers
FROM (
    SELECT 
    customer_key,
    CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
     ELSE 'New'
END customer_segment
FROM customer_spending) t
GROUP BY customer_segment
ORDER BY total_customers DESC
