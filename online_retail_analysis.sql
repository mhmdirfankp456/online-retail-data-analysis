-- =====================================================================
-- Online Retail Sales Analysis (MySQL 8.0)
-- Author  : Mohammed Irfan K P
-- Data    : Cleaned synthetic online retail data (6,201 orders)
-- Table   : retail.orders
-- Note    : Revenue is counted only for orders with status 'Delivered'
--           (returned and cancelled orders did not earn revenue).
-- =====================================================================

-- ONLINE RETAIL SALES ANALYSIS

use retail;

-- check the data first
select * from orders limit 10;

-- total orders
select count(*) as total_orders from orders;

-- Q1. total orders, delivered orders, revenue and average order value
-- (revenue only for delivered orders)
select count(*) as total_orders,
       sum(order_status = 'Delivered') as delivered_orders,
       round(sum(case when order_status = 'Delivered' then revenue end)) as total_revenue,
       round(avg(case when order_status = 'Delivered' then revenue end), 2) as avg_order_value
from orders;

-- Q2. how many orders delivered, returned, cancelled
select order_status,
       count(*) as orders,
       round(count(*) * 100 / (select count(*) from orders), 1) as percentage
from orders
group by order_status
order by orders desc;

-- Q3. revenue by category
select product_category,
       count(*) as orders,
       round(sum(revenue)) as revenue
from orders
where order_status = 'Delivered'
group by product_category
order by revenue desc;

-- Q4. monthly revenue
select date_format(order_date, '%Y-%m') as month,
       round(sum(revenue)) as revenue
from orders
where order_status = 'Delivered' and order_date is not null
group by month
order by month;

-- Q5. top 5 states by revenue
select state, round(sum(revenue)) as revenue
from orders
where order_status = 'Delivered' and state is not null
group by state
order by revenue desc
limit 5;

-- Q6. top 10 products by revenue
select product_name, round(sum(revenue)) as revenue
from orders
where order_status = 'Delivered'
group by product_name
order by revenue desc
limit 10;

-- Q7. payment method share
select payment_method,
       count(*) as orders,
       round(count(*) * 100 / (select count(*) from orders where payment_method is not null), 1) as percentage
from orders
where payment_method is not null
group by payment_method
order by orders desc;

-- Q8. return rate by category
select product_category,
       count(*) as total_orders,
       sum(order_status = 'Returned') as returned_orders,
       round(sum(order_status = 'Returned') * 100 / count(*), 1) as return_rate
from orders
where product_category is not null
group by product_category
order by return_rate desc;

-- Q9. top 10 customers by revenue
select customer_id, count(*) as orders, round(sum(revenue)) as revenue
from orders
where order_status = 'Delivered' and customer_id is not null
group by customer_id
order by revenue desc
limit 10;

-- Q10. month on month growth (compare each month with the previous month)
with monthly as (
    select date_format(order_date, '%Y-%m') as month,
           round(sum(revenue)) as revenue
    from orders
    where order_status = 'Delivered' and order_date is not null
    group by month
)
select month,
       revenue,
       lag(revenue) over (order by month) as previous_month,
       round((revenue - lag(revenue) over (order by month)) * 100
             / lag(revenue) over (order by month), 1) as growth_percent
from monthly
order by month;

-- Q11. best selling product in each category
select product_category, product_name, revenue
from (
    select product_category,
           product_name,
           round(sum(revenue)) as revenue,
           rank() over (partition by product_category order by sum(revenue) desc) as rnk
    from orders
    where order_status = 'Delivered'
    group by product_category, product_name
) t
where rnk = 1;