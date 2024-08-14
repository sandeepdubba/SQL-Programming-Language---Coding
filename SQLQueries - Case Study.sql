SELECT TOP (1000) [receipt_id]
      ,[receipt_date]
      ,[article_id]
      ,[article_description]
      ,[category_id]
      ,[category_description]
      ,[customer_id]
      ,[gst_excluded_amount]
  FROM [Amazonorders].[dbo].[wiq_technical_test_sample_data (2)]

   -- #1 - Write a SQL query to retrieve customer data, include customer ID, last purchase date, and total spend in the last calendar year.
select customer_id, max(receipt_date) as Last_Purchase_Date, round(sum(gst_excluded_amount),2) as Total_Spend
from [wiq_technical_test_sample_data (2)]
where receipt_date between '1-1-2023' and '1-12-2023'
group by customer_id
Order by Total_Spend desc

 -- #2 - Include a filter to only show customers who have made more than 50 purchases.
select customer_id, max(receipt_date) as Last_Purchase_Date, round(sum(gst_excluded_amount),1) as Total_Spend, count(article_description) as Cust_Morethan50Purchases
from [wiq_technical_test_sample_data (2)]
where YEAR(receipt_date)=2023
group by customer_id
having count(article_description)>50

--Write a SQL query to calculate the total sales per product category for the last quarter.
select category_description as Product_Category, sum(gst_excluded_amount) as Total_Sales
from [wiq_technical_test_sample_data (2)]
where receipt_date between '2023-10-1' and '2023-12-31'
group by category_description

--Extend this query to display the average sale value per article within each category.
select article_description as Product_Name, category_description as Product_Category, round(AVG(gst_excluded_amount),2) as Average_Sales
from [wiq_technical_test_sample_data (2)]
group by category_description, article_description
Order by category_description

--Construct a SQL query to identify the top 10% of customers based on their spending in the last year.

With CTE as (select customer_id, round(sum(gst_excluded_amount),1) as Total_Spending, NTILE(10) over (order by sum(gst_excluded_amount )desc) as Percentile_Rank
from [wiq_technical_test_sample_data (2)]
where year(receipt_date) = 2023
group by customer_id)
select customer_id, Total_Spending from CTE where Percentile_Rank = 1

with CTE1 as (select customer_id, round(SUM(gst_excluded_amount),2) as total_spending, NTILE(10) over (order by SUM(gst_excluded_amount) desc) as percentile_rank,
        RANK() over (order by SUM(gst_excluded_amount) desc) as spending_rank
 FROM [wiq_technical_test_sample_data (2)] 
 where year(receipt_date) = 2023
 group by customer_id)
 select customer_id, total_spending, spending_rank from CTE1 where percentile_rank = 1