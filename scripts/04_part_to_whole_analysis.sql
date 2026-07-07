--Which categories contribute the most to overall sales
WITH category_sales AS
(
    SELECT 
p.category,
SUM(s.sales_amount) as total_sales
FROM fact_sales as s
LEFT JOIN dim_products as p
ON p.product_key = s.product_key
GROUP BY p.category
)

SELECT 
category,
total_sales,
SUM(total_sales) OVER () as overall_sales,
CONCAT(ROUND((total_sales/SUM(total_sales) OVER () )* 100,2),'%') as percentage_of_total
FROM category_sales
ORDER BY total_sales DESC