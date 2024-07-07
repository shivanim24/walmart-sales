RENAME TABLE `walmart sales data.csv`  TO sales;

-- Add a new column for storing time
ALTER TABLE sales
ADD COLUMN sale_time TIME;

UPDATE sales
SET sale_time = TIME_FORMAT(`Time`, '%H:%i:%s');

ALTER TABLE sales
DROP COLUMN `Time`;

ALTER TABLE sales
MODIFY COLUMN `Date` DATE;

-- ******************feature engineering***********************

SELECT sale_time,
(CASE 
	WHEN sale_time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN sale_time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE 
		WHEN sale_time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN sale_time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);

--    DAY NAME 
select date ,
dayname(`date`) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name=dayname(`date`);

-- MONTH NAME
select `date`,
monthname(`date`) as month_name
from sales;

alter table sales add column month_name varchar(15);

update sales
set month_name=monthname(`date`);

 -- *************Exploratory Data Analysis************
 
 -- PRODUCT ANALYSIS  
 
 select distinct city from sales;
 select distinct branch,city from sales;
 
 select count(distinct `product line`) from sales;
 
 SELECT payment, COUNT(payment) AS common_payment_method 
FROM sales GROUP BY payment ORDER BY common_payment_method DESC LIMIT 1;

SELECT `product line`, count(`product line`) AS most_selling_product
FROM sales GROUP BY `product line` ORDER BY most_selling_product DESC LIMIT 1;

SELECT month_name, SUM(total) AS total_revenue
FROM SALES GROUP BY month_name ORDER BY total_revenue DESC;

SELECT month_name, SUM(cogs) AS total_cogs
FROM sales GROUP BY month_name ORDER BY total_cogs DESC;

SELECT `product line`, SUM(total) AS total_revenue
FROM sales GROUP BY `product line` ORDER BY total_revenue DESC LIMIT 1;

SELECT city, SUM(total) AS total_revenue
FROM sales GROUP BY city ORDER BY total_revenue DESC LIMIT 1;

SELECT `product line`, SUM(`tax 5%`) as VAT 
FROM sales GROUP BY `product line` ORDER BY VAT DESC LIMIT 1;

ALTER TABLE sales ADD COLUMN product_category VARCHAR(20);

UPDATE sales AS s
JOIN (SELECT AVG(total) AS avg_total FROM sales) AS avg_sales
SET s.product_category = 
    CASE 
        WHEN s.total >= avg_sales.avg_total THEN 'Good'
        ELSE 'Bad'
    END;

SELECT branch, SUM(quantity) AS quantity
FROM sales GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC LIMIT 1;

SELECT gender, `product line`, COUNT(gender) total_count
FROM sales GROUP BY gender, `product line` ORDER BY total_count DESC;

select `product line`,round(avg(rating),2) as average_rating
from sales
group by `product line`
order by average_rating desc ; 

-- SALES ANALYSIS

select day_name ,time_of_day,count(`invoice id`) as total_sales
from sales group by day_name,time_of_day having day_name not in ('Sunday','Saturday');

select `customer type`, sum(total) as revenue
from sales group by `customer type` order by revenue desc limit  1;

select city,sum(`tax 5%`) as  total_tax
from sales group by city order by total_tax desc limit 1;

-- CUSTOMER ANALYSIS

select count(distinct `customer type`) 
from sales;

select count(distinct payment)
from sales;

select `customer type`,count(`customer type`) as common_customer
from sales group by `Customer type` order by common_customer desc limit 1;

select `customer type`,sum(total) as total_sales
from sales group by `customer type` order by total_sales desc ;

select gender,count(*) as genders
from sales group by gender order by genders desc ;

select branch,gender,count(gender) as gender_distribution_per_branch
from sales group by branch,gender order by branch;

select time_of_day,avg(rating) as average_rating
from sales group by time_of_day order by average_rating desc;

select branch,time_of_day,avg(rating) as average_rating
from sales group by branch,time_of_day order by branch,average_rating desc;

select day_name ,avg(rating) as average_rating
from sales group by day_name order by average_rating desc ;

SELECT  branch, day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name, branch ORDER BY average_rating DESC;












