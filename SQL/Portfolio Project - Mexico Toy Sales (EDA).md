# Mexico Toy Sales
## About This Project
This project about Sales & inventory data for a fictitious chain of toy stores in Mexico called Maven Toys, including information about products, stores, daily transactions, and current inventory levels at each location
from January 2020 to September 2023. 

## Data and Tools
I took the data from `Maven Analytis` that can be downloaded [here](https://maven-datasets.s3.amazonaws.com/Maven+Toys/Maven+Toys.zip). This data contain 6 CSV files, and there are 4 files needed for analysis : 
inventory, products, sales, and stores. 

Table Preview
1. Inventory table : store_id, product_id, stock_on_hand
2. Products : product_id, product_name, product_category, product_cost_product_price
3. Sales : sales_id, date, store_id, product_id, units
4. Stores : store_id, store_name, store_city, store_location, store_open_date

Tools I used : `MySQL`

## Analysis Process
The following is the analysis process in this project :
1. Ask Questions to Make Data-Driven Desicions
2. Prepare Data
3. Process Data
4. Analayze Data
5. Summary
6. Recommendation

### 1. Ask Questions to Make Data-Driven Desicions
There are 2 sections of analysis, Exploratory Data and Main Analysis. Here are questions for Exploratory Data, including :
- What is the sales timeline ?
- How many total transactions / total units sold ?
- Most and least product quantity sold ?
- How many stores and products are there ?
- What is the most and least expensive product ? What about the cost ? What about their average ?
- Show the total sales, cost, and profit KPIs
- What is the highest and lowest sales based on products ?
- How were the profit sales for each products? Show highest and lowest profit

Main Analysis
- Which product categories drive the biggest profits? Is this the same across store locations ?
- Can you find any seasonal trends or patterns in the sales data ?
- How were sales trend growth over the months ? What about the profit ?
- How were sales and profit trend growth based on stores and location ? Which stores had the most and least sales and net profit ?
- Are sales being lost with out-of-stock products at certain locations?
- How much money is tied up in inventory at the toy stores? How long will it last?


### 2. Prepare Data
First, I created Maven Toys data base
- Set `LOCAL INFILE` for import CSV file to MySQL
```sql
SET GLOBAL LOCAL_INFILE=ON;
```

- Create database
```sql
CREATE SCHEMA `maven_toys` ;
```

- Create sales table
```sql
CREATE TABLE sales (
	  sales_id INT,
	  dates DATE,
	  store_id INT,
	  product_id INT,
      units INT
  );
```

- Load sales file
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/2. Maven Toys/Maven Toys Data/sales.csv' INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

- Create inventory table
```sql
CREATE TABLE inventory (
	  store_id INT,
	  product_id INT,
	  stock_on_hand INT
  );
```

- Load inventory file
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/2. Maven Toys/Maven Toys Data/inventory.csv' INTO TABLE inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

- Create products table
```sql
CREATE TABLE products (
	  product_id INT,
	  product_name TEXT,
	  product_category TEXT,
      product_cost TEXT,
      product_price TEXT
  );
```

- Load products file
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/2. Maven Toys/Maven Toys Data/products.csv' INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

- Create stores table
```sql
CREATE TABLE stores (
	  store_id INT,
	  store_name TEXT,
	  store_city TEXT,
      store_location TEXT,
      store_open_date DATE
  );
```

- Load stores file
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/2. Maven Toys/Maven Toys Data/stores.csv' INTO TABLE stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

Here is the sql file for creating database [create db.sql](https://github.com/user-attachments/files/22165813/create.db.sql)


### 3. Process Data
Clean and Formatting Data
- Remove $ sign and format cost and price in sales table
```sql
SELECT CAST(REPLACE(product_cost, '$', '') AS DOUBLE) AS product_cost, CAST(REPLACE(product_price, '$', '') AS DOUBLE) AS product_price
FROM products;
```

- Update product_cost and product_price
```sql
UPDATE products
SET product_cost =  CAST(REPLACE(product_cost, '$', '') AS DOUBLE) ,
product_price = CAST(REPLACE(product_price, '$', '') AS DOUBLE);
```

- Change product_cost product_price to double
```sql
ALTER TABLE products
MODIFY COLUMN product_cost DOUBLE,
MODIFY COLUMN product_price DOUBLE;
```

Here is sql file for data cleaning and formatting [data_clean & formatting.sql](https://github.com/user-attachments/files/22165866/data_clean.formatting.sql)


### 4. Analayze Data
To begin with, let's answer the question from Exploratory Data

#### Exploratory Data Analysis
- What is the sales timeline ?
```sql
SELECT MIN(dates) AS min_date, MAX(dates) AS max_dates
FROM sales; -- Sales from Jan 1st 2020 to Sept 30th 2023
```

- How many total transactions / total units sold ?
```sql
SELECT COUNT(sales_id) AS total_transaction
FROM sales; -- There were 829262 transactions
```

```sql
SELECT SUM(units) AS total_units
FROM sales; -- There were 1,090,565 toys sold
```

- Most and least product quantity sold ?
```sql
SELECT product_name, SUM(units) AS total_units
FROM sales s LEFT JOIN products p
	ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY total_units DESC; -- Most toys sold was Colourbuds with 104368 units sold, least toys sold was Mini Basketball Hoop 2647 units
```

- How many stores and products are there ?
```sql
SELECT COUNT(DISTINCT store_name)
FROM stores; -- There were 50 stores
```

```sql
SELECT DISTINCT product_category
FROM products;
```

```sql
SELECT COUNT(DISTINCT product_name)
FROM products; -- There are 35 products and 5 category
```

- What is the most and least expensive product ? What about the cost ? What about their average ?
```sql
SELECT product_name, product_price
FROM products
ORDER BY product_price DESC; -- Most expensive toys was Lego Bricks($39.99), least expensive toys was PlayDoh Can($2.99).
```

```sql
SELECT product_name, product_cost
FROM products
ORDER BY product_cost DESC; -- Highest product cost was Lego Bricks($34.99), lowest product cost was Barel O'Slime($1.99)
```

```sql
SELECT ROUND(AVG(product_cost),1) AS avg_cost, ROUND(AVG(product_price),1) AS avg_price
FROM products; -- avg cost $10.2 , avg price $14.8
```

- Show the total sales, cost, and profit KPIs
```sql
SELECT SUM(total_sales) AS total_sales, SUM(total_cost) AS total_cost, SUM(profit) AS total_profit
FROM sales_cost_profit; -- Total sales $14M, Total Cost $10M, adn Total Profit $4M
```

- What is the highest and lowest sales based on products ?
```sql
WITH cte AS (
	SELECT product_name, units * product_price AS sales
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id)
SELECT product_name, ROUND(SUM(sales)) AS total_sales
FROM cte
GROUP BY product_name
ORDER BY total_sales DESC; -- Highest sales was Lego Bricks(Over $2.3M) and lowest sales was Uno Card Game($21K)
```

- How were the profit sales for each products? Show highest and lowest profit
```sql
WITH cte AS (
	SELECT product_name, ROUND(SUM(units * product_price)) AS sales, ROUND(SUM(units * product_cost)) AS cost
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id
	GROUP BY product_name)
SELECT product_name, sales - cost AS profit
FROM cte
GROUP BY product_name
ORDER BY profit DESC; -- Highest profit was Colourbuds ($834K) and lowest profit was Classic Dominoes ($8K)
```


#### Main Analysis

- Which product categories drive the biggest profits? Is this the same across store locations ?
```sql
WITH cte AS (
	SELECT product_category, ROUND(SUM(units * product_price)) AS sales, ROUND(SUM(units * product_cost)) AS cost
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id
	GROUP BY product_category)
SELECT product_category, sales - cost AS profit
FROM cte
GROUP BY product_category
ORDER BY profit DESC; -- Toys was had the biggest profit over $1M.
```

```sql
WITH cte AS (
	SELECT store_location, product_category, ROUND(SUM(units * product_price)) AS sales, ROUND(SUM(units * product_cost)) AS cost
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id
	LEFT JOIN stores st
		ON s.store_id = st.store_id
	GROUP BY store_location, product_category)
SELECT store_location, product_category, sales - cost AS profit
FROM cte
GROUP BY store_location, product_category
ORDER BY store_location, profit DESC; -- Toys was the biggest profit in Downtown and Residential, while Electronis was the biggest profit in Airport and Commercial
```

- Can you find any seasonal trends or patterns in the sales data ?
```sql
SELECT YEAR(dates) AS years, QUARTER(dates) AS quarters, ROUND(SUM(units * product_price)) AS total_sales
FROM sales s LEFT JOIN products p
	ON s.product_id = p.product_id
GROUP BY YEAR(dates), QUARTER(dates); -- In 1st Q and 3rd Q of 2022 sales reached over $1.6M , but since the last quarter of 2022 until 3rd Q 2023 sales reached over $2M, with 2nd Q 2023 had the highest sales over the quarters
```

- How were sales trend growth over the months ? What about the profit ?

For this question, i had to create new table of total_sales, total_cost and total_profit over the months because i wanted the query simple, short and easy to read
```sql
CREATE TABLE sales_cost_profit (
WITH monthly_sales AS (
	SELECT DATE_FORMAT(dates, '%b') AS months, YEAR(dates) AS years, ROUND(SUM(units * product_price)) AS total_sales
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id
	GROUP BY DATE_FORMAT(dates, '%b'), YEAR(dates)),
monthly_profit AS (
	SELECT DATE_FORMAT(dates, '%b') AS months, YEAR(dates) AS years, ROUND(SUM(units * product_cost)) AS total_cost
	FROM sales s LEFT JOIN products p
		ON s.product_id = p.product_id
	GROUP BY DATE_FORMAT(dates, '%b'), YEAR(dates))

SELECT ms.months, ms.years, total_sales, total_cost, total_sales - total_cost AS profit
FROM monthly_sales ms JOIN monthly_profit mp
	ON ms.months = mp.months AND ms.years = mp.years);
```

```sql
WITH cte AS (
WITH monthly_sales AS (
	SELECT months, years, total_sales, LAG(total_sales, 1) OVER () AS prev_sales
	FROM sales_cost_profit)
SELECT *, ROUND((total_sales - prev_sales) / prev_sales * 100, 1) AS percent_growth
FROM monthly_sales)
SELECT months, years, total_sales, 
	CASE
		WHEN percent_growth > 0 THEN CONCAT('▲', ' ', percent_growth, '%')
		WHEN percent_growth < 0 THEN CONCAT('▼', ' ', percent_growth, '%')
        END AS growth
FROM cte; -- The highest sales growth was in December 2022, with 31.6% from the previous month.
```

```sql
WITH cte AS (
	SELECT months, years, total_sales, LAG(total_sales, 1) OVER () AS prev_sales
	FROM sales_cost_profit)
SELECT *, ROUND((total_sales - prev_sales) / prev_sales * 100, 1) AS percent_growth
FROM cte
WHERE months IN ('Feb', 'May', 'Jun', 'Aug')
ORDER BY percent_growth ASC; -- In February, May, June, and August of 2022 and 2023, sales often declined from -0.2% to -20.2%, making August 2023 the month with the lowest sales in this period.
```

```sql
WITH cte AS (
	WITH monthly_profit AS (
		SELECT months, years, profit, LAG(profit, 1) OVER () AS prev_profit
		FROM sales_cost_profit)
	SELECT *, ROUND((profit - prev_profit) / prev_profit * 100, 1) AS percent_growth
	FROM monthly_profit)
SELECT months, years, profit, 
	CASE 
		WHEN percent_growth > 0 THEN CONCAT('▲', ' ', percent_growth, '%')
		WHEN percent_growth < 0 THEN CONCAT('▼', ' ', percent_growth, '%')
		END AS growth
FROM cte; -- The highest net profit was recorded in December 2022, 27.6% higher than the previous month. This is a difference of 44.2% from the lowest profit in August 2023, which was -16.6%.
```

- How were sales and profit trend growth based on stores and location ? Which stores had the most and least sales and net profit ?

For this question, i had to create new table of total_sales, total_cost and total_profit based on stores and location because i wanted the query simple, short and easy to read

```sql
CREATE TABLE stores_sales_cost_profit (
	WITH sales_by_store AS (
		SELECT store_name, store_city, store_location, ROUND(SUM(units * product_price)) AS total_sales, ROUND(SUM(units * product_cost)) AS total_cost
		FROM sales s LEFT JOIN products p
			ON s.product_id = p.product_id
		LEFT JOIN stores st
			ON s.store_id = st.store_id
		GROUP BY store_name, store_city, store_location)
	SELECT *, total_sales - total_cost AS profit
	FROM sales_by_store);
```

```sql
SELECT store_name, store_city, store_location, total_sales
FROM stores_sales_cost_profit
ORDER BY total_sales DESC;
-- The store with the highest sales is Maven Toys Ciudad de Mexico 2, Cuidad de Mexico, located at the airport, with total sales of $554K.
-- The store with the lowest sales, Maven Toys Campeche 2, is located in the commercial area of Campeche with total sales of $206K.
```

```sql
SELECT store_name, store_city, store_location, profit
FROM stores_sales_cost_profit
ORDER BY profit DESC;
-- Maven Toys Ciudad de Mexico 2 also earned the highest profit of $169K. However, the lowest profit was in the Downtown area of Cuernavaca, where Maven Toys Cuernavaca 1 earned only $56K.
```

- How were profit performance based on location?
```sql
SELECT store_location, SUM(profit) AS profit, 
ROUND((SUM(profit) / (SELECT SUM(profit) FROM stores_sales_cost_profit)) * 100) AS percent_profit,
SUM(total_sales) AS sales, 
ROUND((SUM(total_sales) / (SELECT SUM(total_sales) FROM stores_sales_cost_profit)) * 100) AS percent_sales
FROM stores_sales_cost_profit
GROUP BY store_location;
-- The largest profits from sales occurred in the Downtown area with over $2 million, which is 56% greater than the total profits of all locations.
-- Perhaps because the stores in this area are located in the city center, there is a high level of activity and they are easily accessible to many people.
-- The lowest profit was at the airport location at $378K, 9% of total profits. This contrasts with the Maven Toys Ciudad de Mexico 2 store, which generated the highest profit in the airport area.
```

- Are sales being lost with out-of-stock products at certain locations?
```sql
SELECT sales_id, dates, s.store_id, s.product_id, store_location, store_city
FROM sales s LEFT JOIN inventory i
	ON s.product_id = i.product_id
    AND s.store_id = i.store_id
LEFT JOIN stores st
	ON s.store_id = st.store_id
WHERE stock_on_hand = 0 AND sales_id IS NULL; -- There were no sales being lost with out-of-stock products at certain location
```

- How much money is tied up in inventory at the toy stores? How long will it last?
```sql
WITH cte AS (
	SELECT stock_on_hand, product_cost, stock_on_hand * product_cost AS tied_up
	FROM inventory i LEFT JOIN products p
		ON i.product_id = p.product_id
	WHERE stock_on_hand > 0)
SELECT ROUND(SUM(tied_up))
FROM cte; -- The amount of money tied up in inventory was a little over $300K
```

- How long will it last? To solve this using Days Of Supply Calculation
- Days of Supply = (Current Inventory Level) / (Average Daily Usage Rate)

```sql
WITH cte AS (
	SELECT (SELECT SUM(stock_on_hand) FROM inventory) AS stock, ROUND(AVG(total_units)) AS avg_per_day FROM (
	SELECT dates, SUM(units) AS total_units
	FROM sales
	GROUP BY dates) AS sub)
SELECT ROUND(stock / avg_per_day) AS stock_day
FROM cte; -- stock on hand in the inventory will last for max 17 days
```

Here is sql file for full analyze [EDA.sql](https://github.com/user-attachments/files/22166439/EDA.sql)


### Summary
The analysis of toy sales data in Mexico from January 2020 to September 2023 provides a comprehensive overview of performance and key trends. 
Total sales reached $14 million, generating a net profit of $4 million from 829,262 transactions and 1,090,565 toys sold. The average selling price was $14.8 per item, with an average cost of $10.2.
Colourbuds was the top-performing toy, with 104,368 units sold and the highest profit at $834K. Lego Bricks generated the highest total sales, exceeding $2.3 million. 
The Toys category as a whole was the most profitable, with over $1 million in profit. Conversely, the Mini Basketball Hoop was the least sold toy, while Classic Dominoes had the lowest profit at just $8K.
In terms of location and sales trends, Downtown stores were the most profitable, with over $2 million in profit, which is 56% higher than the total profit of all other locations combined. 
This is likely due to their central and accessible locations. The Airport store location had the lowest overall profit, even though the Maven Toys Ciudad de Mexico 2 store, 
which is located in an airport, had the highest sales and profit. Sales showed consistent growth from late 2022 to mid-2023, with the second quarter of 2023 recording the highest sales. 
The peak sales growth occurred in December 2022 (a 31.6% increase from the previous month), while sales typically declined in February, May, June, and August. 
The current inventory is estimated to last for a maximum of 17 days, but no sales were lost due to out-of-stock products.


### Recommendation
Product Strategy
- Focus on Top-Performing Products: Double down on the success of Colourbuds and Lego Bricks. These are proven winners.
Consider increasing their stock levels and giving them more prominent placement in stores and online promotions.
- Re-evaluate Underperforming Products: The data shows that products like Uno Card Game and Classic Dominoes have very low sales and profit.
It's worth considering whether to reduce their inventory, bundle them with other products, or even phase them out to free up shelf space for more profitable items.


Sales And Marketing Recommendation
- Capitalize on Holiday Sales: The huge sales spike in December 2022 and the general positive trend in late 2022 and mid-2023 indicates that holiday seasons are key.
Plan the biggest marketing campaigns, promotions, and inventory pushes for November and December to maximize these high-traffic periods.
- Boost Low-Performing Months: Sales consistently drop in February, May, June, and August. To counteract this, you could run special promotions,
flash sales, or create "summer" and "back-to-school" campaigns during these months to drive more traffic and revenue.
- Leverage Location Strengths: The Downtown locations are clearly your biggest profit drivers. Invest more in these stores through enhanced product displays and localized marketing.
Although the Airport locations have a low overall profit, the success of the Maven Toys Ciudad de Mexico 2 store shows that high-traffic airport stores can be very profitable.
Analyze what makes that specific store successful and try to replicate those strategies at other airport locations.


Inventory and Operations
- Optimize Stock Levels: The current inventory is estimated to last only 17 days. While it's good that there were no out-of-stock issues, this indicates a very lean inventory.
A more robust supply chain strategy is needed to prevent potential stockouts during peak sales periods like December. Consider implementing a just-in-case inventory model for your top sellers to maintain a safety buffer.
- Investigate Profit Discrepancies: The low profit at the Cuernavaca Downtown store ($56K) is unusual given that Downtown locations are generally the most profitable.
This requires a deeper look into that specific store's operations, costs, and local competition to identify and fix the issue. The same applies to the low profit at
the overall Airport locations despite having a high-profit store.



> [!NOTE]
> This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You.

