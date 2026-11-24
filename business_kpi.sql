-- cities - city_id, city_name, state, region, has_express
-- customers - customer_id, customer_name, gender, age_group, city_id, signup_date, acquisition_channel
-- products - product_id, product_name, category, brand_type, composition, mrp, selling_price, requires_rx
-- orders - order_id, customer_id, order_datetime, delivery_type, delivered_datetime, order_status, payment_mode, order_value
-- order_items - order_item_id, order_id, product_id, quantity, unit_price, item_status, substituted_from_product_id
-- lab_tests - test_id, test_name, test_category, price
-- phlebotomists-  phlebotomist_id, phlebotomist_name, city_id, joining_date
-- lab_bookings - booking_id, customer_id, test_id, phlebotomist_id,  booking_datetime, collection_status, booking_amount
-- consultations - consult_id, customer_id, specialty, consult_datetime, consult_mode, fee, consult_status

-- How much total revenue did the pharmacy business generate between January 2025 and October 2026? 
SELECT 
    SUM(order_value) as total_revenue
FROM
    orders
WHERE
    order_datetime >= '2025-01-01'
        AND order_datetime < '2026-11-01'
        AND order_status = 'Delivered';
        
-- What is the average amount customers spend per delivered pharmacy order?
SELECT 
    ROUND(AVG(order_value), 2) AS Average_amount
FROM
    orders
WHERE
    order_status = 'Delivered';

-- for october 2026 find total orders, delivered orders, revenue and average order values
SELECT 
	COUNT(*) as total_order,
    SUM(order_status = 'Delivered') as delivered_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN order_value END) as total_revenue,
    ROUND(AVG(CASE WHEN order_status = 'Delivered' THEN order_value END), 0) AS Average_ordervalue
FROM
    orders
WHERE
    order_datetime >= '2026-10-01'
        AND order_datetime < '2026-11-01';
      
-- List the top 10 cities by number of orders, with each city's % share of all orders 
-- concat(round((count(orders.order_id) / (select count(order_id) from orders)) * 100, 2), "%") as percetange_of_total
SELECT 
    cities.city_name, COUNT(orders.order_id) as orders, 
    round(100 * count(*) / sum(count(*)) over (), 2) as percentage_total
FROM
    cities
        JOIN
    customers ON cities.city_id = customers.city_id
        JOIN
    orders ON customers.customer_id = orders.customer_id
GROUP BY cities.city_name
order by percentage_total desc limit 10;

-- for each express city, find the % of express orders delivered after 60 minutes 
with express as (select cities.city_name,timestampdiff(MINUTE,orders.order_datetime,orders.delivered_datetime)as time_taken from cities join customers
using(city_id)
join orders 
using(customer_id)
 where orders.delivery_type = 'Express')

select city_name, round((sum(time_taken > 60)/ count(time_taken)) * 100 , 2) percent_of_late_express from express
group by city_name
order by percent_of_late_express desc;

-- How much pharmacy revenue was generated in each month from January 2025 to October 2026?
select  date_format(order_datetime,'%Y-%m') as month_year, sum(order_value) as monthly_revenue from orders where order_datetime >= '2025-01-01' AND order_datetime < '2026-11-01'
group by month_year;

-- Which 10 cities generated the highest pharmacy revenue with rank
select cities.city_name, sum(order_value) as total_revenue, DENSE_RANK() OVER (ORDER BY sum(order_value) DESC) AS revenue_rank from cities join customers using(city_id) join orders using(customer_id) where order_status = 'delivered'
group by cities.city_name
order by total_revenue desc limit 10;