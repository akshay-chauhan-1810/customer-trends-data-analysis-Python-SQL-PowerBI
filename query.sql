
select * from customer limit 20

-- 1. What is the total revenue genrated by male vs female customers?

select gender, sum(purchase_amount) as revenue
from customer
group by gender

-- 2. Which customers used a discount but still spend more than the average purchase amount?

select custome from customer 
where customer.discount_appiled = 'Yes'

-- Which are the top 5 product with highest average review rating?
select item_purchased, ROUND(AVG(review_rating::numeric), 2) as "Average product rating"
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- 4. Compare the avearge purchase amounts between standard and express shipping

select shipping_type, ROUND(AVG(purchase_amount), 2)
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type


-- 5. Do subscribe customers spen more? compare average spend and total revenue

select subscription_status, COUNT(customer_id) , ROUND(AVG(purchase_amount), 2) as avg_spend, sum(purchase_amount) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;


-- 6. Which 5 product have the highest percentage of purchase with discount applied?

select item_purchased,
100 * sum(case when discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- 7. Segment customers into New, Returning, and Loyal based on their total number 
-- of previous purchases, and show count of each segment.

with customer_type as (
select customer_id, previous_purchases,
case 
	when previous_purchases = 1 THEN 'New'
	when previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END as customer_segment
from customer
)

select customer_segment, count(*) as "Number of customer"
from customer_type
group by customer_segment


-- 8. What are the top 3 most purchased prodcuts within each category?


with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;

-- 9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

-- 10. What is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc






