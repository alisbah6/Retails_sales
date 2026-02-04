use sql_project1;
drop table if exists retail_sales;
CREATE TABLE retail_sales
(
    transactions_id NVARCHAR(15) PRIMARY KEY,
    sale_date      NVARCHAR(15),
    sale_time      NVARCHAR(15),
    customer_id    NVARCHAR(15),
    gender         NVARCHAR(10),
    age            NVARCHAR(15),
    category       NVARCHAR(30),
    quantity       NVARCHAR(15),
    price_per_unit NVARCHAR(15),
    cogs           NVARCHAR(15),
    total_sale     NVARCHAR(15)
);

select * from retail_sales;

ALTER TABLE retail_sales
ALTER COLUMN sale_date DATE;

ALTER TABLE retail_sales
ALTER COLUMN sale_time TIME;

ALTER TABLE retail_sales
ALTER COLUMN customer_id INT;

ALTER TABLE retail_sales
ALTER COLUMN age INT;

ALTER TABLE retail_sales
ALTER COLUMN quantity INT;

ALTER TABLE retail_sales
ALTER COLUMN price_per_unit FLOAT;

ALTER TABLE retail_sales
ALTER COLUMN cogs FLOAT;

ALTER TABLE retail_sales
ALTER COLUMN total_sale FLOAT;

SELECT name
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('retail_sales');

ALTER TABLE retail_sales DROP CONSTRAINT PK__retail_s__23518609969A6F15

ALTER TABLE retail_sales
ALTER COLUMN transactions_id INT NOT NULL;

ALTER TABLE retail_sales
ADD CONSTRAINT PK_retail_sales
PRIMARY KEY (transactions_id);

SELECT TOP 10 * FROM retail_sales 

SELECT COUNT(*) FROM retail_sales

--DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL


UPDATE retail_sales set quantity=NULL where quantity=0
UPDATE retail_sales set price_per_unit=NULL where price_per_unit=0
UPDATE retail_sales set cogs=NULL where cogs=0
UPDATE retail_sales set total_sale=NULL where total_sale=0

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE from retail_sales WHERE
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category from retail_sales

-- Data Analysis & Business Key Problems & Answers

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
Select * from retail_sales where category='Clothing' and  sale_date between '2022-11-01' and '2022-11-30' and quantity>=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) as total_sale_by_category,count(total_sale) as total_order  from retail_sales group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) as average_age  from retail_sales where category='Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * from retail_sales where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(*) as total_transactions from retail_sales group by gender,category order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT  
sales_year,sales_month,avg_total_sales from 
(SELECT Year(sale_date) as sales_year,Month(sale_date) as sales_month,AVG(total_sale) as avg_total_sales,
RANK() Over(partition by YEAR(sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by YEAR(sale_date),MONTH(sale_date)
) as t1 where rank=1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Select TOP 5 customer_id,sum(total_sale) as total_sales from retail_sales group by customer_id order by 2 desc;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,Count(distinct(customer_id)) as unique_cust from retail_sales group by category

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales AS 
(
SELECT *,
CASE
WHEN datepart(hour,sale_time)<'12' THEN 'Morning'
WHEN datepart(hour,sale_time) between '12' and '17' THEN 'Afternoon'
ELSE 'Evening'
END as shifts
FROM retail_sales )
select shifts,count(*) as total_orders from hourly_sales
Group by shifts

--END OF PROJECT

