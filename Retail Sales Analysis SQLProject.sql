CREATE DATABASE IF NOT EXISTS retail_sales_analysis;

-- -- create table
DROP TABLE IF EXISTS retail_sales_analysis;
CREATE TABLE retail_sales_analysis (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);



-- EDA
-- we check the count of the data to make sure we have imported all the data 

SELECT 
    COUNT(*)
FROM
    retail_sales_analysis;

-- Check for the null Values

SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
-- Data Exploration
-- How many sales we have?
SELECT 
    COUNT(*)
FROM
    retail_sales_analysis;

-- HOW MANY CUSTOMERS WE HAVE
SELECT 
    COUNT(DISTINCT (customer_id))
FROM
    retail_sales_analysis;

-- HOW MANY CATAGORIES WE HAVE
SELECT 
    COUNT(DISTINCT (category))
FROM
    retail_sales_analysis;

-- Data Analysis and Business questions
-- 1) Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- 2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.
-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- 5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- 7) Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
-- 8) Write a SQL query to find the top 5 customers based on the highest total sales.
-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.
-- 10) Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).


SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    sale_date = '2022-11-05';

-- 2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    category = 'Clothing'
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
        AND quantity >= 4;
        
-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS overall_sale
FROM
    retail_sales_analysis
GROUP BY category;

-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    AVG(age)
FROM
    retail_sales_analysis
WHERE
    category = 'Beauty';

-- 5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    transactions_id
FROM
    retail_sales_analysis
WHERE
    total_sale > 1000;

-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(transactions_id)
FROM
    retail_sales_analysis
GROUP BY category , gender;

-- 7) Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
select year_sale, month_sale, avg_sale from
(
	select year(sale_date) as year_sale,
			month(sale_date) as month_sale,
			avg(total_sale) as avg_sale,
			rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rank_month
	from retail_sales_analysis
	group by year(sale_date), month(sale_date) 
) as t1
where rank_month = 1;
-- order by year, avg_sale desc


-- 8) Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales_analysis
GROUP BY customer_id
ORDER BY total_sales DESC
limit 5;

-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category, 
    count(distinct(customer_id)) as unique_customers
 from retail_sales_analysis
 group by category;
 
 -- 10) Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale AS (
    SELECT 
        CASE 
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales_analysis
)
SELECT 
    shift, 
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- Project Ends