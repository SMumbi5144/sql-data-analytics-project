/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value
       - average monthly spend
===============================================================================
*/
CREATE VIEW report_customers AS
WITH base_query as
(
/*-----------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
------------------------------------------------------------------------------*/
SELECT 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) as customer_name,
EXTRACT(YEAR FROM AGE(NOW(),c.birthdate)) as age
FROM fact_sales as s
LEFT JOIN dim_customers as c
ON c.customer_key = s.customer_key
WHERE order_date IS NOT NULL)

,customer_aggregation as 
(
/*----------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
-----------------------------------------------------------------*/
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) as total_orders,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
COUNT(DISTINCT product_key) as total_products,
MAX(order_date) as last_order_date,
EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) * 12 +
EXTRACT(MONTH FROM AGE(MAX(order_date),MIN(order_date))) as lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE WHEN age < 20 THEN 'Under 20'
         WHEN age between 20 and 29 THEN '20-29'
         WHEN age between 30 and 39 THEN '30-39'
         WHEN age between 40 and 49 THEN '40-49'
         ELSE '50 and above'
END as age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
     ELSE 'New'
END customer_segment,
    total_orders,
    total_sales,
    total_quantity,
    last_order_date,
    EXTRACT(YEAR FROM AGE(NOW(),last_order_date)) * 12 +
    EXTRACT(MONTH FROM AGE(NOW(),last_order_date)) as recency,
    lifespan,
--Compute average order value(AVO)
CASE WHEN total_orders = 0 THEN 0
    ELSE total_sales/total_orders 
END  avg_order_value,
--Compute average monthly spend
CASE WHEN lifespan = 0  THEN total_sales
    ELSE  ROUND((total_sales/lifespan)::NUMERIC,0)
END  avg_monthly_spend
FROM customer_aggregation


