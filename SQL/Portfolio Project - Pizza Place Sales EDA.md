# Pizza Place Sales Data Analysis

## About This Project
A year's worth of sales from a fictitious pizza place, including the date and time of each order and the pizzas served, with additional details on the type, size, quantity, price, and ingredients.

## Data and Tools
In this project I used **MySQL** for Exploratory Data and **Tableau** for Visualization Tools. The Data From **Maven Analytics**, 
link download [here](https://maven-datasets.s3.amazonaws.com/Pizza+Place+Sales/Pizza+Place+Sales.zip). MySQL file script [EDA.sql](https://github.com/user-attachments/files/22106752/EDA.sql)
I created dashboard viz using **Tableau** [click here](https://public.tableau.com/app/profile/juliatera.tambunan/viz/PizzaPlaceSalesDashboard_17565421684080/Dashboard1).

## Required Analysis Steps
In this portfolio project, I took several steps necessary to analyze data, from creating a database to visualizing the data. The steps are as follows:
1.  Create Database (Creating the database using **MySQL** from Raw Data)
2.  Exploratory Data Analysis (Find KPIs such as total sales, time period, total orders etc)
3.  Main Analysis (Main objectives of analysis to find insights)
4.  Summary of Analysis


### 1. Create Database
- Set `LOCAL_INFILE = ON;` in MySQL to import CSV file
```sql
SET GLOBAL LOCAL_INFILE=ON;
```

- Create schema
```sql
CREATE SCHEMA `pizza_d` ;
```

- Create table order_details
```sql
CREATE TABLE order_details (
	  order_details_id INT,
	  order_id INT,
	  pizza_id TEXT,
	  quantity INT
  );
```

- Load data order_details
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/1. Pizza Place/pizza_sales/order_details.csv' INTO TABLE order_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

- Create table orders
```sql
CREATE TABLE orders (
	  order_id INT,
	  date_order DATE,
	  time_order TIME
  );
```

- Load data orders
```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/1. Pizza Place/pizza_sales/orders.csv' INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

> [!NOTE]
> For the `pizza_types` and `pizzas` tables i used Table data import wizard because both of this tables have a little rows.
> For the `order_details` and `orders` tables i used `LOCAL INFLIE` to read both order_detail and orders CSV file from my PC

Here is the SQL file script for creating database [create pizza db.sql](https://github.com/user-attachments/files/22107419/create.pizza.db.sql)

### 2. Exploratory Data Analysis

- Use database
```sql
USE pizza_db;
```

- Sales Period
```sql
SELECT MIN(date_order) AS min_date, MAX(date_order) AS max_order
FROM orders; -- Sales period from the beginning of January 2015 to the end of December 2015
```

- Total Orders and Quantity Sold
```sql
SELECT COUNT(order_details_id) AS total_orders, SUM(quantity) AS total_quantity
FROM order_details; -- There were 48,620 transactions and 49,574 items sold during this period.
```

- How many items are offered on the menu?
```sql
SELECT COUNT(DISTINCT `name`)
FROM pizza_types; -- There were 32 items that offered on the menu
```

- What are the most expensive and cheapest items?
```sql
SELECT pizza_id, price
FROM pizzas
ORDER BY price; -- The cheapest pizza is Pepperoni Pizza S ($9.75) and the most expensive is The Greek Pizza XXL ($35.95).
```

### 3. Main Analysis

- How many customers do we have each day? Are there any peak hours?
```sql
SELECT ROUND(AVG(num_order))
FROM
	(SELECT DAYNAME(date_order) AS day_order, COUNT(o.order_id) AS num_order
	FROM order_details od LEFT JOIN orders o
		ON od.order_id = o.order_id
	GROUP BY day_order
	ORDER BY num_order) AS total_cust; -- There are 6,946 average total customers every day.
```

```sql
SELECT HOUR(time_order) AS hour_order, COUNT(o.order_id) AS num_cust
	FROM order_details od LEFT JOIN orders o
		ON od.order_id = o.order_id
	GROUP BY hour_order
    ORDER BY num_cust DESC; -- The busiest time was at 12 noon with a total of 6,543 customers. This may be due to lunch break
```
<img width="914" height="58" alt="Customer by Hour" src="https://github.com/user-attachments/assets/b9a253eb-c9ef-43ad-b6e2-495f9f726a19" />
<img width="441" height="95" alt="Customer by Weekday" src="https://github.com/user-attachments/assets/db966db7-6b14-40e8-8d63-da26f3deaa89" /> 


-  How many pizzas are typically in an order? Do we have any bestsellers?
```sql
SELECT quantity, COUNT(quantity) AS total_quan
FROM order_details
GROUP BY quantity; -- Usually customers order one pizza.
```

```sql
SELECT pizza_id, SUM(quantity) AS total
FROM order_details
GROUP BY pizza_id
ORDER BY total DESC; -- The best-selling pizza is The Big Meat Pizza in size S (1,914 total orders). Perhaps because the price is relatively cheap compared to others.
```
<img width="342" height="155" alt="PIzzas typically bought in an order" src="https://github.com/user-attachments/assets/b2a5ed21-a66c-4b5f-85b6-f82e7235899b" />
<img width="436" height="225" alt="Best Seller Pizza" src="https://github.com/user-attachments/assets/2821d183-1143-49f1-82e8-2c233a8dcf48" />


- How much money did we make this year? Can we indentify any seasonality in the sales?
```sql
SELECT ROUND(SUM(price)) AS total_price
FROM order_details o LEFT JOIN pizzas p
	ON o.pizza_id = p.pizza_id; -- Total revenue from pizza sales: $801,945
```

```sql
SELECT QUARTER(date_order) AS quarters,  ROUND(SUM(price)) AS total_sales
FROM order_details od LEFT JOIN pizzas p
	ON od.pizza_id = p.pizza_id
LEFT JOIN orders o
	ON od.order_id = o.order_id
GROUP BY quarters; -- From the beginning of Q1 to Q3, sales did not show significant movement, but declined slightly in Q4.
```
<img width="229" height="153" alt="Sales by Quarter" src="https://github.com/user-attachments/assets/5dff0f72-bd9d-4ab0-860f-fbad03229a17" />


- What are the monthly sales trends? Are there any specific patterns? Show the difference each month in percentage
```sql
SELECT MONTHNAME(date_order) AS months, ROUND(SUM(price)) AS total_sales
FROM order_details od LEFT JOIN orders o
	ON od.order_id = o.order_id
LEFT JOIN pizzas p
	ON od.pizza_id = p.pizza_id
GROUP BY months
ORDER BY total_sales; -- Pizza sales fluctuated slightly throughout the year between $62K and $69K, but the highest sales occurred in July at around $71K.
```

```sql
WITH percent_diff AS (
	WITH monthly_sales AS (
		SELECT MONTHNAME(date_order) AS months, ROUND(SUM(price)) AS total_sales
		FROM order_details od LEFT JOIN orders o
			ON od.order_id = o.order_id
		LEFT JOIN pizzas p
			ON od.pizza_id = p.pizza_id
		GROUP BY months)
			SELECT months, total_sales, LAG(total_sales, 1) OVER() AS prev_sales
			FROM monthly_sales
			GROUP BY months)
SELECT months, total_sales, ROUND((total_sales - prev_sales) / prev_sales *100,2) AS percentage_difference
FROM percent_diff; -- From October to November, pizza sales grew from $62,566 to $69,054, an increase of 10.37%. However, sales in the following month of December were $63,450, a significant decrease of -8.12%.
```
<img width="1530" height="785" alt="Monthly Sales Trend" src="https://github.com/user-attachments/assets/55d4d72e-b1a3-4712-a4c7-0bdb14608657" />


- Identify Sales trend in Running Total
```sql
SELECT DATE_FORMAT(date_order, '%m') AS months, ROUND(SUM(price)) AS total, ROUND(SUM(SUM(price)) OVER(ORDER BY DATE_FORMAT(date_order, '%m'))) AS running_total
FROM order_details od LEFT JOIN orders o
	ON od.order_id = o.order_id
LEFT JOIN pizzas p
	ON od.pizza_id = p.pizza_id
GROUP BY months; 
```


- Are there any pizzas we should take of the menu, or any promotions we could leverage?
```sql
SELECT od.pizza_id, name, SUM(quantity) AS total_quan, ROUND(SUM(price)) AS total_sales
FROM order_details od LEFT JOIN pizzas p
	ON od.pizza_id = p.pizza_id
LEFT JOIN pizza_types pt
	ON p.pizza_type_id = pt.pizza_type_id
GROUP BY od.pizza_id, name
ORDER BY total_quan DESC, total_sales DESC; -- The Greek Pizza XXL could be considered for removal from the menu because it was only sold 28 times in 2015, with total sales of $1,007. Perhaps its high price is the reason customers rarely buy it.

-- Meanwhile, The Big Meat Pizza (S) and The Thai Chicken Pizza (L) can be considered for promotion because both menus are very popular and their total sales are very high compared to others.
```
<img width="450" height="188" alt="are there any pizza 1" src="https://github.com/user-attachments/assets/4af00e90-8753-468d-9fac-175b8f8690ef" />
<img width="450" height="200" alt="are there any pizza 2" src="https://github.com/user-attachments/assets/7361be9f-4609-4fd7-832f-934b58284b1e" />


### 4. Summary Of Analysis
The following is a summary of the analysis results :

Overall Performance
- The pizza place operated from January to December 2015, processing 48,620 transactions and selling 49,574 pizza items.
- Total revenue for the year was $801,945.
- The menu featured 32 different items, with prices ranging from the lowest-priced Pepperoni Pizza S ($9.75) to the most expensive The Greek Pizza XXL ($35.95).

Sales and Customer Behaviour
- On average, there were 6,946 customers daily.
- The peak time for sales was 12 PM, with a total of 6,543 customers, likely due to the lunch rush.
- Customers typically ordered one pizza per transaction.
- Sales showed slight fluctuations throughout the year, ranging from $62K to $69K per month. The highest sales month was July, with revenue reaching around $71K.
- Sales saw a notable increase of 10.37% from October to November, but then experienced a significant decline of -8.12% in December.

Menu Insights
- The Big Meat Pizza (S) was the best-selling item with 1,914 total orders, likely due to its relatively low price. This makes it a great candidate for promotional campaigns.
- Similarly, The Thai Chicken Pizza (L) is also a popular menu item with high sales, making it another strong option for promotions.
- In contrast, The Greek Pizza XXL was the least popular item, selling only 28 times for a total of $1,007. Its high price is likely a deterrent for customers, and it could be considered for removal from the menu.


> [!NOTE]
> This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

