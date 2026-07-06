SELECT 
EXTRACT(YEAR FROM order_date)as order_year,
EXTRACT(MONTH FROM order_date) as order_month,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year,order_month
ORDER BY order_year,order_month

SELECT 
DATE_TRUNC('month',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date

SELECT 
DATE_TRUNC('year',order_date)::DATE as order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year',order_date)::DATE
ORDER BY DATE_TRUNC('year',order_date)::DATE
