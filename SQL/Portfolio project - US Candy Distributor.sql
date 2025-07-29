-- This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You.

## Sales and geospatial factory to customer shipment data for a US national candy distributor, inlcuding information around customer & factory locations, sales orders & goals, and product details.
## This data contains sales details from January 2021 to December 2024.
## This data set is also taken from Maven Analysis. Data set download -> (https://app.mavenanalytics.io/datasets)

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Data analysis to find insights
## There ara 4 main objectives :
-- 1. Which product lines have the best product margin? which factory produces the biggest margin? What about the least?
-- 2. Which product lines should be moved to a different factory to optimize shipping routes?
-- 3. how are the sales trends each year? Is there a specific time when sales peak?
-- 4. find the top 3 regions with the most sales. and what are the top 3 products from each region?
-- 5. Do sales meet the targets of each division until 2024?
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

## View & understanding data
USE us_candy_distributor;
SELECT * FROM factories;
SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM targets;
SELECT * FROM uszips;

-- 1. Which product lines have the best product margin? which factory produces the biggest margin? What about the least?
SELECT product_name, ROUND (total_gross/total_sales *100,2) AS margin
FROM (
	SELECT product_name, ROUND(SUM(sales)) AS total_sales, ROUND(SUM(gross_profit)) AS total_gross
	FROM sales
	GROUP BY product_name) AS total_margin
ORDER BY margin DESC; -- Everlasting Gobstopper is a product line with a margin of around 80%

-- which factory produces the biggest margin? What about the least?
SELECT factory, ROUND (total_gross/total_sales *100,2) AS margin_percentage
FROM (
	SELECT factory, ROUND(SUM(sales)) AS total_sales, ROUND(SUM(gross_profit)) AS total_gross
	FROM sales s LEFT JOIN products p
	ON s.product_id = p.product_id
	GROUP BY factory) AS total_margin
ORDER BY margin_percentage DESC; -- Lot's O' Nuts has the largest margin at almost 70%, followed by Wicked Choccy's which makes over 65%.
								 -- Meanwhile, The Other Factory, produced the smallest margin at less than 12%.

-- 2. Which product lines should be moved to a different factory to optimize shipping routes?
SELECT s.product_name, factory, region, COUNT(s.product_id) AS total_product
FROM sales s LEFT JOIN products p
	ON s.product_id = p.product_id
GROUP BY s.product_name, factory, region
ORDER BY factory; -- Product lines such as Wonka Bar - Milk Chocolate and Wonka Bar - Triple Dazzle Caramel were suggested to move to the Lot's O' Nuts factory, as the Lot's O' Nuts factory received the most Wonka Bar orders and shipped nationwide and overseas.

-- 3. How are the sales trends each year? 
WITH year_sales AS ( -- Find total sales each year
	SELECT YEAR(order_date) AS years, ROUND(SUM(sales)) AS total
	FROM sales
	GROUP BY years)
SELECT years, total, ROUND((total/SUM(total) OVER ()),3) *100 AS percent_diff -- find the percentage difference of the whole
FROM year_sales
GROUP BY years; -- In 2021, sales were at 20.4% of the total. Sales began to increase in 2023 to around 26% and peaked in 2024, reaching over 33%.

-- Is there a specific time when sales peak?
SELECT *, total_sales - prev_total AS diff_sales, ROUND(((total_sales - prev_total)/prev_total),2)*100 AS percent_diff FROM (
WITH monthly_sales AS (
	SELECT YEAR(order_date) AS years, MONTH(order_date) AS months, ROUND(SUM(sales)) AS total_sales
	FROM sales
	GROUP BY years, months)
SELECT years, months, total_sales, LAG(total_sales, 1) OVER (ORDER BY years) AS prev_total
FROM monthly_sales) AS diff
ORDER BY percent_diff DESC; -- The highest sales period occurred in March 2021, which experienced an exponential sales spike of around 311%.
							-- In 2022 to 2024, sales also experienced a significant increase of around 100 to 127% in the same month.

-- 4. find the top 3 regions with the most sales. and what are the top 3 products from each region?
SELECT state_province, ROUND(SUM(sales)) AS total_sales
FROM sales
GROUP BY state_province
ORDER BY total_sales DESC
LIMIT 3; -- California, New York, and Texas generated the most sales in the US. Total sales were highest in California at $27,917, followed by New York at $15,541, and Texas at $13,416.

-- what are the top 3 products from each region?
SELECT * FROM (
WITH cte AS (
	SELECT state_province, product_name, ROUND(SUM(sales)) AS total
	FROM sales
	GROUP BY 1,2)
SELECT *, ROW_NUMBER() OVER (PARTITION BY state_province ORDER BY total DESC) AS popular
FROM cte) AS top_3
WHERE state_province IN ('California', 'New York', 'Texas') AND popular < 4; -- The most popular product among this region is the Wonka Bar chocolate.
-- Wonka Bar - Triple Dazzle Caramel, Wonka Bar - Milk Chocolate, Wonka Bar -Scrumdiddlyumptious, and Wonka Bar - Fudge Mallows are the top 3 products with the highest sales in each of these regions.

-- 5. Do sales meet the targets of each division until 2024?
SELECT *, target - total AS remaining_targets,
CASE 
	WHEN ((target - total)/target *100) < 100 THEN CONCAT(FORMAT(((target - total) / target * 100), 2), ' % to go')
	ELSE 'fulfilled' END AS `status`
FROM (
	SELECT s.division, target, COUNT(s.division) AS total
	FROM sales s LEFT JOIN targets t
		ON s.division = t.division
	GROUP BY 1) AS target_diff; -- The Chocolate division still has 63.54% of its sales target, while the Other and sugar Divisions each have 89.67% and 99.73% of their sales target, respectively.

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Analysis conclusion results :
	-- Everlasting Gobstopper is a product line with a margin of around 80%
	-- Lot's O' Nuts has the largest margin at almost 70%, followed by Wicked Choccy's which makes over 65%.
	-- Meanwhile, The Other Factory, produced the smallest margin at less than 12%.
	-- Product lines such as Wonka Bar - Milk Chocolate and Wonka Bar - Triple Dazzle Caramel were suggested to move to the Lot's O' Nuts factory, as the Lot's O' Nuts factory received the most Wonka Bar orders and shipped nationwide and overseas.
	-- In 2021, sales were at 20.4% of the total. Sales began to increase in 2023 to around 26% and peaked in 2024, reaching over 33%.
	-- The highest sales period occurred in March 2021, which experienced an exponential sales spike of around 311%.
	-- In 2022 to 2024, sales also experienced a significant increase of around 100 to 127% in the same month.
	-- California, New York, and Texas generated the most sales in the US. Total sales were highest in California at $27,917, followed by New York at $15,541, and Texas at $13,416.
	-- The most popular product among this region is the Wonka Bar chocolate.
	-- Wonka Bar - Triple Dazzle Caramel, Wonka Bar - Milk Chocolate, Wonka Bar -Scrumdiddlyumptious, and Wonka Bar - Fudge Mallows are the top 3 products with the highest sales in each of these regions.
	-- The Chocolate division still has 63.54% of its sales target, while the Other and sugar Divisions each have 89.67% and 99.73% of their sales target, respectively.















