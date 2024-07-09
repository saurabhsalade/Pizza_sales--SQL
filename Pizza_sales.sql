
-- Basic:
-- Q1 Retrieve the total number of orders placed.

-- Select count(order_id) as total from orders;

-- Q2 Calculate the total revenue generated from pizza sales.

-- Select round(Sum(quantity*price),2) 
-- from orders_details o join pizzas p on o.pizza_id=p.pizza_id; 

-- Q3Identify the highest-priced pizza.

-- Select pt.name, p.price
-- from pizza_types pt join  pizzas p on pt.pizza_type_id=p.pizza_type_id order by price desc limit 1;
-- or using window function

-- with temp as
-- (select dense_rank() over(order by price desc ) as rn from pizza_types pt join  pizzas p on pt.pizza_type_id=p.pizza_type_id)
-- Select p.name from temp where rn=1;

-
-- with temp as
-- (select pt.name, p.price,dense_rank() over(order by price desc ) as rn from pizza_types pt join  pizzas p on pt.pizza_type_id=p.pizza_type_id)
-- Select name, price from temp where rn=1;


-- Q4 Identify the most common pizza size ordered.
-- Select p.size, sum(od.quantity) as s
-- from orders o join orders_details od on o.order_id=od.order_id join pizzas p on p.pizza_id=od.pizza_id group by p.size order by s desc limit 1; 

-- or using window

-- with temp as
--  (select p.size, sum(od.quantity) as s,  dense_rank () over(order by sum(quantity) desc) as rn 
--  from  orders o join orders_details od on o.order_id=od.order_id join pizzas p on p.pizza_id=od.pizza_id group by p.size)
--  Select size, s from temp where rn=1;


--  Q5 List the top 5 most ordered pizza types along with their quantities.
-- Select name, sum(quantity) as c 
-- from pizza_types pt join pizzas p on pt.pizza_type_id = p.pizza_type_id join orders_details od on od.pizza_id=p.pizza_id 
-- group by name order by c desc limit 5;

-- using Window 

-- with temp as
-- (select name, sum(quantity)as s, dense_rank() over(order by sum(quantity) desc)as rn
--  from pizza_types pt join pizzas p on pt.pizza_type_id = p.pizza_type_id join orders_details od on od.pizza_id=p.pizza_id
--  group by name) Select name, s from temp where rn between 1 and 5;



-- Intermediate:

--  Q1 Join the necessary tables to find the total quantity of each pizza category ordered.
-- Select category, sum(quantity) as s
-- from pizza_types pt join pizzas p on pt.pizza_type_id = p.pizza_type_id join orders_details od on od.pizza_id=p.pizza_id 
-- group by category  order by s;
 
 -- or using window
 --
--  select category, s  from
-- (select category, sum(quantity) as s, dense_rank() over(order by sum(quantity)) as rn from pizza_types pt join pizzas p on pt.pizza_type_id = p.pizza_type_id join orders_details od on od.pizza_id=p.pizza_id 
--  group by category) as temp

--  Q2 Determine the distribution of orders by hour of the day.
-- select count(order_time), Hour(order_time) from orders GROUP by Hour(order_time);


-- Q3 Join relevant tables to find the category-wise distribution of pizzas.
-- Select category, count(name)
-- from pizza_types group by category;

--  Q4  Group the orders by date and calculate the average number of pizzas ordered per day.
-- Select round(AVG(qa),0)  from 
-- (Select o.order_date, sum(od.quantity) as qa
-- from orders o join orders_details od where o.order_id = od.order_id group by o.order_date) as order_quant;

-- Q5  Determine the top 3 most ordered pizza types based on revenue.
-- Select name, sum(quantity*price)as revenue 
-- from pizza_types pt join pizzas p on pt.pizza_type_id=p.pizza_type_id 
-- join orders_details od on od.pizza_id=p.pizza_id
-- group by pt.name order by revenue desc limit 3;

 

-- Advanced:
-- Q1 Calculate the percentage contribution of each pizza type to total revenue.

-- STEP 1, Calculate Total Revenue fir each pizza
-- With pizza_revenue as 
-- (Select pt.category, SUM(o.quantity*p.price) as revenue
-- from pizza_types pt join pizzas p on pt.pizza_type_id=p.pizza_type_id
-- join orders_details o on o.pizza_id= p.pizza_id group by pt.category order by revenue desc),
-- -- STEP 2 calculate the overall revenue
-- total_revenue as(
-- select SUM(revenue) as total_revenue from pizza_revenue)
-- -- STEP 3 compute the % contribution
-- Select pr.category, pr.revenue,
-- (pr.revenue/tr.total_revenue)*100 As percent_contribution
-- from pizza_revenue pr,total_revenue tr
-- order by percent_contribution;




-- Q2 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
-- Select name, revenue, category from
-- (select category, name, revenue, dense_rank() over(partition by category order by revenue desc) 
-- as rn from
-- (Select pt.category,pt.name, sum((od.quantity)*p.price) as revenue 
-- from pizza_types pt join pizzas p on pt.pizza_type_id=p.pizza_type_id 
-- join orders_details od on od.pizza_id=p.pizza_id
-- group by pt.category, pt.name) as x  ) as y  where rn<=3;                                                                          


