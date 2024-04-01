SELECT * FROM datawalmart.walmartsalesdata;

------------------------------------------------------ Feature Enginnering -----------------------------------------------------------------------

------------------------------------------------------ time_of_day --------------------------

select time from datawalmart.`walmartsalesdata`;


SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM `walmartsalesdata`;

-- creating new columns
alter TABLE `walmartsalesdata` add column time_of_day varchar(20) ;

-- inserting data into the column
update  walmartsalesdata 
set  time_of_day=(
    CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-------------------------------------------------------------- day_name -----------------------------------------------
UPDATE walmartsalesdata SET Date = STR_TO_DATE(Date, '%d-%m-%Y');

SELECT date, dayname(date) as day_name FROM walmartsalesdata;

-- creating new column
alter table walmartsalesdata add column day_name varchar(12);

-- inserting data into the column
update walmartsalesdata set day_name = dayname(Date);

-------------------------------------------------------------- month_name------------------------------------------------
select date , monthname(date) as month_name from walmartsalesdata;

-- creating new column
alter table walmartsalesdata add column month_name varchar(12);

-- inserting data into the column
update walmartsalesdata set month_name = monthname(DATE);


-------------------------------------------------------------------------------- Exploratory data Analysis---------------------------------------------------------------

-- Q1 How many unique cities does the data have ?
select count(distinct city) as unique_cities from walmartsalesdata; 


-- Q2 In which city is each branch ?
select distinct City , Branch from `walmartsalesdata`;

------------------------------------- Product ---------------------------------------------------

-- Q1 How many Unique product lines does the data have?
select distinct product_line from walmartsalesdata;
select count(distinct product_line) from walmartsalesdata;

-- Q2 What is the most common payment method?
select payment, count(payment) as cnt  from walmartsalesdata group by payment order by cnt desc;
select max(payment) from walmartsalesdata;

-- Q3 what is the most selling product line?
select product_line, count(product_line) as cnt from walmartsalesdata group by product_line order by cnt desc;

-- Q4 What is the total revenue by month?
select month_name , sum(revenue) as revenue from walmartsalesdata  group by month_name order by revenue desc;

-- Q5 What month had the largest COGS?
select month_name , sum(cogs) as cogs from walmartsalesdata  group by month_name order by cogs desc;

-- Q6 What product line had the largest revenue?
select product_line , sum(revenue) as revenue  from walmartsalesdata group by product_line order by revenue desc;
select product_line , sum(revenue) as revenue  from walmartsalesdata group by product_line order by revenue desc limit 1;

-- Q7 What is the city with the largest revenue?
select city , sum(revenue) as revenue  from walmartsalesdata group by city order by revenue desc;

-- Q8 What product line had the largest vat?
select product_line , sum(VAT) as VAT from  walmartsalesdata  group by product_line order by VAT desc;

-- Q9 what branch sold more products than average product sold?
select branch, sum(quantity) as qty from walmartsalesdata  group by branch having  sum(quantity)>(select avg(quantity) from walmartsalesdata) order by qty desc  limit 1;

-- Q10 what is the most product_line by gender?
select gender ,count(product_line) as product_line from  walmartsalesdata  group by gender order by product_line desc limit 1;

-- Q11 What is the average rating of each product line?
select product_line, round(avg(rating),2) as avg from walmartsalesdata group by product_line order by avg desc ;

--------------------------------------------------------- Sales -----------------------------------------------------------------

 -- Q1 Number of sales made in each time of the day per weekday
 select time_of_day ,count(*) as sales from walmartsalesdata group by time_of_day ;
 
 -- Q2 Which of the customer types brings the most revenue
 select customer_type , sum(revenue) as revenue from walmartsalesdata group by Customer_type order by  revenue desc;
 
 -- Q3 Which city has the largest tax percent/VAT?
 select city, avg(VAT) as VAT from walmartsalesdata group by  city order by VAT desc;
 
 -- Q4 Which customer type pays the most in VAT?
  select customer_type, sum(VAT) as VAT from walmartsalesdata group by  customer_type order by VAT desc;
