-- SQL Retail Sales Analysis 
CREATE DATABASE sql_project_p2;

-- create table 
drop table if exists retail_sales;
create table retail_sales ( transactions_id INT primary key ,
sale_date Date,
sale_time time,
customer_id	int,
gender	Varchar(6),
age	int,
category Varchar(25),
quantiy int,
price_per_unit int,
cogs float,
total_sale float );

select * from retail_sales;



-- Handling Null Values 

select * from retail_sales
where transactions_id IS NULL 
OR sale_date IS NULL 
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL 
OR age IS NULL 
OR category IS NULL 
OR quantiy IS NULL
OR price_per_unit IS NULL 
OR cogs IS NULL 
OR total_sale IS NULL ;


-- **Cleaning the data** 
-- Deleting the null values which dont have any sales amount transaction
DELETE FROM retail_Sales 
where  transactions_id IS NULL 
OR sale_date IS NULL 
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL  
OR category IS NULL 
OR quantiy IS NULL
OR price_per_unit IS NULL 
OR cogs IS NULL 
OR total_sale IS NULL ;

-- filling the missing values of age 
select *, coalesce (age,(select avg(age) from retail_sales))
from retail_sales ;


-- Update the real table , where there is not any  null values 
UPDATE retail_sales
SET age = (
    SELECT AVG(age)
    FROM retail_sales
    WHERE age IS NOT NULL
)
WHERE age IS NULL;

-- fresh table covering no null values 
select * from retail_sales
where transactions_id IS NULL 
OR sale_date IS NULL 
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL 
OR age IS NULL 
OR category IS NULL 
OR quantiy IS NULL
OR price_per_unit IS NULL 
OR cogs IS NULL 
OR total_sale IS NULL ;

-- Data Exploration

-- How much Sales we have ?

select sum(total_Sale) as Sales 
from retail_sales;

-- counting the total number of different customers 
select count(distinct(customer_id)) as customers
from retail_sales;

-- how many categories we have ?

select distinct(category) as Unique_category 
from retail_Sales;


-- DATA ANALYSIS

-- BUSINESS QUESTIONS 


--QUE 1. Retrieve all columns for sales made on '2022-11-05'

select * from retail_Sales 
where sale_date = '2022-11-05';

--QUE 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2
-- in month of nov -2022

select * from retail_sales
where category = 'Clothing'
AND quantiy > 2
AND EXTRACT(MONTH FROM sale_date) = 11
AND EXTRACT(YEAR FROM sale_date)= 2022;

--QUE 3. calculate the total sales of each categories 

select category , sum(total_sale)as sales , count(*) as Orders_count
from retail_sales 
group by category;

--Que 4. find the average age of customers who purchased items for the 'Beauty' Category.

select round(avg(age),2) as avg_age 
from retail_sales
where category = 'Beauty';

--Que 5. Find all the transaction where the total sale is greater than 1000.

select * 
from retail_sales 
where total_sale > 1000 ;

-- Que 6. Find the total number of transaction made by each gender in each category.


select count(transactions_id) as number_of_trnct , category , gender 
from retail_sales
group by category , gender;

-- Que 7. Calculate average sale of each month . find out best selling month in each year 




SELECT* 
FROM (
SELECT 
    AVG(total_sale) AS total_sales,
    EXTRACT(MONTH FROM sale_date) AS month,
    EXTRACT(YEAR FROM sale_date) AS year,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS MAX_MONTH
FROM retail_sales
GROUP BY year, month)T1
WHERE T1.MAX_MONTH = 1;


-- Que 8. find top 5 customers based on highest total sales

select sum(total_sale)as sales, customer_id
from retail_sales
group by customer_id 
order by sales desc
limit 5;

-- Que 9. Find the number of Unique customers who purchased items for each category

select count(distinct(customer_id)) as unique_customers , category 
from retail_sales 
group by category ;




-- Que 10. Create each shift and number of orders (Example morning <=12, afternoon between 12 and 17 , evening >17)

WITH HOURLY_SALE AS (
select *,
  CASE 
    WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_bin
FROM retail_sales
)
SELECT time_bin , 
count(*) as total_order
from hourly_sale
group by time_bin;

------ END OF PROJECT-------