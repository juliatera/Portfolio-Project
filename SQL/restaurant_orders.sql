-- This is a data analysis about orders in a restaurant.
-- A quarter's worth of orders from a fictitious restaurant serving international cuisine, including the date and time of each order, 
-- the items ordered, and additional details on the type, name and price of the items.
-- This data source is taken from open sources. You can download the data -> (https://app.mavenanalytics.io/guided-projects/d7167b45-6317-49c9-b2bb-42e2a9e9c0bc)

-- There are 3 main objectives for this analysis.
-- 1. Understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.
-- 2. Understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.
-- 3. Find the least and most ordered categories, and dive into the details of the highest spend orders.

-- Which cuisines should we focus on developing more menu items for based on the data? For this conclusion is in the very end of line code!

-- Query start HERE!

-- First objective : Understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.

-- 1. View the menu_items table and write a query to find the number of items on the menu
SELECT COUNT(item_name) AS num_item
FROM menu_items; -- There are 32 items in the menu

-- 2. What are the least and most expensive items on the menu?
SELECT *
FROM menu_items
ORDER BY price; -- the least price item is Edamame and the most expensive is Shrimp Scampi
-- ORDER BY price DESC;

-- 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT COUNT(item_name) AS num_italian_menu
FROM menu_items
WHERE category = 'Italian'; -- There are 9 Italian dishes on the menu

SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price; -- the least price item for Italian dishes is Spaghetti and the most expensive Italian dishes is Shrimp Scampi

-- 4. How many dishes are in each category? What is the average dish price within each category?
SELECT category, COUNT(item_name)
FROM menu_items
GROUP BY category; -- Italian and Mexican category each have 9 items, while American have 6 items and Asian have 8.

-- What is the average dish price within each category?
SELECT category, AVG(price)
FROM menu_items
GROUP BY category; 


-- Second objective : Understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.
-- 1. View the order_details table. What is the date range of the table?
SELECT MIN(date_clean), MAX(date_clean) FROM (
SELECT STR_TO_DATE(order_date, '%m/%d/%y') AS date_clean
FROM `order`) AS date_format; -- date range is from 2023-01-01 to 2023-03-01

-- 2. How many orders were made within this date range? How many items were ordered within this date range?
SELECT COUNT(DISTINCT order_id)
FROM `order`; -- There are 5370 order id within this date range

SELECT COUNT(*)
FROM `order`; -- There ara 12234 items were ordered within this date range

-- 3. Which orders had the most number of items?
SELECT order_id, COUNT(item_id) AS total_item
FROM `order`
GROUP BY order_id
ORDER BY total_item DESC; -- There are 7 order id that had the most orders

-- 4. How many orders had more than 12 items?
SELECT COUNT(total_item) FROM
(SELECT order_id, COUNT(item_id) AS total_item
FROM `order`
GROUP BY order_id
HAVING total_item > 12) AS items; -- There are 20 order id that had more than 12 items


-- Third objective : Find the least and most ordered categories, and dive into the details of the highest spend orders.
-- 1. Combine the menu_items and order_details tables into a single table
SELECT *
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id;

-- 2. What were the least and most ordered items? What categories were they in?
SELECT item_name, category, COUNT(order_details_id) AS num_order
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id
GROUP BY item_name, category
ORDER BY num_order; -- DESC -- The least ordered items were Mexican food, which is Chicken Tacos. The most ordered items were American food which is Hamberger.

-- 3. What were the top 5 orders that spent the most money?
SELECT order_id, ROUND(SUM(price),2) AS total_price
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id
GROUP BY order_id
ORDER BY total_price DESC
LIMIT 5; -- The top 5 orders spent more than 185 dollars and order_id spent the most is 440

-- 4. View the details of the highest spend order. Which specific items were purchased?
SELECT order_id, item_name, COUNT(item_name) AS item, category
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id
WHERE order_id = 440
GROUP BY category, item_name; -- Looks like order_id that spent the most on Italian food like Spaghetti and Fettucine

-- 5. View the details of the top 5 highest spend orders
SELECT order_id, category, COUNT(item_name) AS item
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category
ORDER BY order_id, item DESC; -- 4 out of 5 highest spend oder id, spent the most items on Italian food.  

-- Were there certain times that had more or less orders?
SELECT DATE_FORMAT((STR_TO_DATE(order_date, '%m/%d/%y')), '%M') AS m_date, COUNT(order_details_id) AS total_order
FROM `order`
GROUP BY m_date
ORDER BY total_order; -- In February, the number of orders was less compared to March.

-- Which cuisines should we focus on developing more menu items for based on the data?
SELECT category, item_name, COUNT(item_name) total_item
FROM `order` o LEFT JOIN menu_items m
	ON o.item_id = m.menu_item_id
GROUP BY category, item_name
ORDER BY total_item DESC; -- Since Hamburger and Edamame are the most sold menu items in the data, it is worth considering expanding these two menus.









