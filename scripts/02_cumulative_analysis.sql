-- Calculate the total sales per month
-- and the running total of sales over time

--STEP 1: Basic view of order_date and sales
SELECT 
order_date, sales_amount
FROM fact_sales

--STEP 2:Added sum of sales by month
SELECT 
DATE_TRUNC('month',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month',order_date)::DATE
ORDER BY DATE_TRUNC('month',order_date):: DATE

--STEP 3: Added running total of sales  per month
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER ( ORDER BY order_date) AS running_total_sales
FROM
(
    SELECT 
DATE_TRUNC('month',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month',order_date)::DATE
)

--STEP 4: Added Running totals of sales by year
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
    SELECT 
DATE_TRUNC('year',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year',order_date)::DATE
)

--Addition: Moving Average of the price
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
ROUND(AVG(avg_price) OVER (ORDER BY order_date)::NUMERIC,0) as moving_average_price
FROM
(
    SELECT 
DATE_TRUNC('year',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales,
AVG(price)as avg_price
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year',order_date)::DATE
)