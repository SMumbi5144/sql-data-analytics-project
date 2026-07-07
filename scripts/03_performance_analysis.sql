/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */

--Yearly performance of products
SELECT
 EXTRACT('year' FROM s.order_date) as order_year,
 p.product_name,
 SUM(s.sales_amount) as current_sales 
 FROM fact_sales as s
 LEFT JOIN dim_products as p
 ON s.product_key = p.product_key
 WHERE s.order_date IS NOT NULL
 GROUP BY  EXTRACT('year' FROM s.order_date) ,p.product_name

 --Comparison of product sales to their average sales performance
 WITH yearly_product_sales as (
    SELECT
 EXTRACT('year' FROM s.order_date) as order_year,
 p.product_name,
 SUM(s.sales_amount) as current_sales 
 FROM fact_sales as s
 LEFT JOIN dim_products as p
 ON s.product_key = p.product_key
 WHERE s.order_date IS NOT NULL
 GROUP BY  EXTRACT('year' FROM s.order_date) ,p.product_name
 )
 SELECT 
 order_year,
 product_name,
 current_sales,
 ROUND(AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) as avg_sales,
 ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) as diff_avg,
 CASE WHEN  ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) > 0 THEN 'Above Avg'
      WHEN  ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) < 0 THEN 'Below Avg'
      ELSE 'Avg'
END avg_change
 FROM yearly_product_sales
 ORDER BY product_name,order_year

--Comparison of current product sales with  previous year sales
WITH yearly_product_sales as (
    SELECT
 EXTRACT('year' FROM s.order_date) as order_year,
 p.product_name,
 SUM(s.sales_amount) as current_sales 
 FROM fact_sales as s
 LEFT JOIN dim_products as p
 ON s.product_key = p.product_key
 WHERE s.order_date IS NOT NULL
 GROUP BY  EXTRACT('year' FROM s.order_date) ,p.product_name
 )
 SELECT 
 order_year,
 product_name,
 current_sales,
 ROUND(AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) as avg_sales,
 ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) as diff_avg,
 CASE WHEN  ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) > 0 THEN 'Above Avg'
      WHEN  ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)::NUMERIC,0) < 0 THEN 'Below Avg'
      ELSE 'Avg'
END avg_change,
--Year-on-year Analysis
LAG(current_sales)OVER (PARTITION BY product_name ORDER BY order_year) as py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as diff_py,
CASE WHEN  current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
      WHEN  current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
      ELSE 'No Change'
END py_change
 FROM yearly_product_sales
 ORDER BY product_name,order_year
