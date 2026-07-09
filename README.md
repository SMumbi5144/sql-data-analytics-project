# SQL Data Analytics Project

## About This Project
This project explores a sales dataset using SQL, following Data With Baraa's 
Advanced Analytics portfolio project. I built it using PostgreSQL, pgAdmin, 
and VS Code (with the SQLTools extension), adapting all queries from SQL 
Server syntax to PostgreSQL syntax along the way.

The dataset covers customers, products, and sales transactions. I explored 
the data, analyzed trends over time, and built two final reports that 
summarize key business insights.

## Business Problem
A retail company selling bikes, accessories, and clothing needed a clearer
picture of two things: which products were actually driving revenue, and
which customers were the most valuable to retain. Without this, the business 
had no easy way to answer questions like "should we double down on bikes?" 
or "who are our most loyal customers and how do we keep them engaged?"

This project answers those questions by building reusable SQL reports that 
segment customers by value and products by performance, so decision-makers
can quickly see where the business is winning and where there's room to grow.

## Tools Used
- PostgreSQL (database)
- pgAdmin (database management)
- VS Code + SQLTools extension (writing and running queries)
- GitHub (version control)

## Project Structure
```
sql-data-analytics-project/
├── datasets/   # Raw CSV data 
(customers, products, sales)
├── scripts/   # All SQL scripts,
organized by topic
│ ├── 01_change_over_time.sql
│ ├── 02_cumulative_analysis.sql
│ ├── 03_performance_analysis.sql
│ ├── 04_part_to_whole_analysis.sql
│ ├── 05_data_segmentation.sql
│ ├── 06_customer_reporting.sql
│ └── 07_product_reporting.sql
└── README.md
```

## What Each Script Does
- **Change Over Time**: Looks at how sales changed month by month and year by year.
- **Cumulative Analysis**: Calculates running totals of sales over time.
- **Performance Analysis**: Compares each product's yearly sales to its average and to the previous year.
- **Part-to-Whole Analysis**: Shows what percentage each product category contributes to total sales.
- **Data Segmentation**: Groups products into cost ranges, and groups customers into VIP, Regular, and New based on spending and how long they've been active.
- **Customer Report**: A single view that pulls together each customer's spending, order history, and segment.
- **Product Report**: A single view that pulls together each product's sales, orders, and performance segment.

## Sample Report Output
Below are sample results from the two final reporting views built in this project.

**Customer Report** - combines each customer's spending, order history, and segment(VIP, Regular or New) into one queryable view.
<img width="1122" height="382" alt="image" src="https://github.com/user-attachments/assets/04224b8e-7b75-4fa9-a420-201ef9b43b10" />


**Product Report** - combines each product's sales, orders, and performance segment(High-Performance, Mid-Range or Low-Performer) into one queryable view.
<img width="1127" height="386" alt="image" src="https://github.com/user-attachments/assets/00895afd-2ed7-4aac-b820-eac1d605031a" />




## Key Insights
- **Bikes** generate the most total revenue by far, but they don't have the highest number of orders,accessories actually has more individual orders, just at a lower price point per sale.
- The best-selling individual product is **Mountain-200 Black-46**, with total sales of 1,373,454.
- The lowest-selling individual product is **Racing Socks-L**, with total sales of just 2,430.
- Out of all customers: **14,826 are New**, **2,039 are Regular**, and **1,617 are VIP**.
- Out of all products: **66 are High-Performers**, **58 are Mid-Range**, and **6 are Low-Performers**.

## How to Use This Project
1. Load the CSV files from `datasets/` into a PostgreSQL database.
2. Run the scripts in `scripts/` in order (01 through 07).
3. The final two scripts create two views — `report_customers` and 
   `report_products` — that can be queried directly for reporting, e.g.:
   ```sql
   SELECT * FROM report_customers;
   SELECT * FROM report_products;

## Note on Adapting from SQL Server to PostgreSQL
This project was originally taught using SQL Server syntax. Throughout the scripts, functions were adapted to PostgreSQL equivalents, for example:

- `YEAR()` → `EXTRACT(YEAR FROM ...)`
- `DATEDIFF()` → `AGE()` combined with `EXTRACT()`
- `GETDATE()` → `NOW()`
- `TOP` → `LIMIT`

About Me

GitHub: [github.com/SMumbi5144](https://github.com/SMumbi5144)

