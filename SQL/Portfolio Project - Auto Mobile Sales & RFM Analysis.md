# Auto Mobile Sales & RFM Analysis

## About Project, Data and Tools
This is a sales analysis and customer segmentation project using Recency Frequency Monetary (RFM) analysis. The purpose of this project is to improve analytical skills, which are then shared as portfolio.
The data used was taken from open sources, `Kaggle` [Download](https://www.kaggle.com/datasets/ddosad/auto-sales-data/data). Tools I used `MySQL`.

## Data Description
The dataset contains Sales data of an Automobile company.

- `order_number` This column represents the unique identification number assigned to each order.
- `quantityordered` It indicates the number of items ordered in each order. 
- `price_each` This column specifies the price of each item in the order. 
- `orderline_number` It represents the line number of each item within an order. 
- `sales` This column denotes the total sales amount for each order, which is calculated by multiplying the quantity ordered by the price of each item. 
- `order_date` It denotes the date on which the order was placed. 
- `days_since_lastorder` This column represents the number of days that have passed since the last order for each customer. It can be used to analyze customer purchasing patterns. 
- `status_` It indicates the status of the order, such as "Shipped," "In Process," "Cancelled," "Disputed," "On Hold," or "Resolved." 
- `productline` This column specifies the product line categories to which each item belongs. 
- `msrp` It stands for Manufacturer's Suggested Retail Price and represents the suggested selling price for each item. 
- `product_code` This column represents the unique code assigned to each product. 
- `customer_name` It denotes the name of the customer who placed the order.
- `phone` This column contains the contact phone number for the customer. 
- `address_line1` It represents the first line of the customer's address.
- `city` This column specifies the city where the customer is located.
- `postal_code` It denotes the postal code or ZIP code associated with the customer's address.
- `country` This column indicates the country where the customer is located.
- `contact_last_name` It represents the last name of the contact person associated with the customer.
- `contact_first_name` This column denotes the first name of the contact person associated with the customer.
- `dealsize` It indicates the size of the deal or order, which are the categories "Small," "Medium," or "Large."

## Analysis Step
There are several stages of analysis in this portfolio :

1. Create Database & Import Data
2. Data Cleaning & Formatting
3. Exploratory Data
4. RFM Analysis

## 1. Create Database & Import Data
- Create Database Schema
```sql
CREATE TABLE sales_data (
	  order_number INT,
      quantityordered INT,
      price_each DOUBLE,
      orderline_number INT,
      sales DOUBLE,
      order_date TEXT,
	  days_since_lastorder INT,
      status_ TEXT,
      productline TEXT,
      msrp INT,
	  product_code CHAR(10),
	  customer_name CHAR(35),
	  phone VARCHAR(20),
      address_line1 VARCHAR(50),
      city TEXT,
      postal_code VARCHAR(10),
      country TEXT,
      contact_last_name TEXT,
      contact_first_name TEXT,
      dealsize TEXT
  );
```

- Import Data
```sql
SET GLOBAL LOCAL_INFILE=ON;
```

```sql
LOAD DATA LOCAL INFILE 'C:/Users/djoel/Documents/Data Analisis Bootcamp/Project/Data Analysis/4. Automobile Sales Data/Auto Sales data.csv' INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

## 2. Data Cleaning & Formatting
- Formating `order_date` column
```sql
SELECT str_to_date(order_date, '%d/%m/%Y')
FROM automobile.sales_data;
```

```sql
UPDATE sales_data
SET order_date =  str_to_date(order_date, '%d/%m/%Y');
```

```sql
ALTER TABLE sales_data
MODIFY COLUMN order_date DATE;
```

## 3. Exploratory Data
- Date Range
```sql
SELECT MIN(order_date), MAX(order_date)
FROM sales_data;
```
> 6th Jan 2018 to 31st May 2020

- Number of customer
```sql
SELECT DISTINCT CONCAT(contact_first_name, " ",contact_last_name) AS cust_name
FROM sales_data;
```
> 89 Customer

- Product line category
```sql
SELECT DISTINCT productline
FROM sales_data; 
```
> There are 7 category, Motorcycles, Classic Cars, Trucks and Buses, Vintage Cars, Planes, Ships, and Trains

- Purchasing country
```sql
SELECT DISTINCT country
FROM sales_data;
```
> There are USA, France, Norway, Australia, Finland, Austria, UK, Spain, Sweden, Singapore, Canada, Japan, Italy, Denmark, Belgium, Philippines, Germany, Switzerland, and Ireland

- What was the total sales ?
```sql
SELECT ROUND(SUM(sales)) AS total_sales
FROM sales_data;
```
> $9,760,222

- Monthly sales from 2018 - 2020
```sql
SELECT MONTH(order_date) AS months, YEAR(order_date) AS years, ROUND(SUM(sales)) AS total_sales
FROM sales_data
GROUP BY 1,2
ORDER BY 2,1;
```

- How was the quarter sales growth?
```sql
WITH quarter_sales AS (
	SELECT YEAR(order_date) AS years, QUARTER(order_date) AS quarter, ROUND(SUM(sales)) AS total_sales, LAG(ROUND(SUM(sales)),1) OVER() AS prev_quarter_sales
	FROM sales_data
	GROUP BY 1,2)

SELECT *, ROUND((total_sales - prev_quarter_sales) / prev_quarter_sales *100,2) AS percentage_difference
FROM quarter_sales;
```
> The highest quarterly sales growth occurred in Q4 2018, at 164% from the previous quarter.
> It then declined sharply in Q1 2019 to -52%, increased to 78% in Q4 2019, and then declined again in Q1 and Q2 2020.

- 2018 sales growth analysis
```sql
WITH prev_month_sales AS (
	WITH monthly_sales AS (
		SELECT MONTH(order_date) AS months, YEAR(order_date) AS years, ROUND(SUM(sales)) AS rev
		FROM sales_data
		WHERE YEAR(order_date) = 2018
		GROUP BY 1,2
		ORDER BY 1)

	SELECT months, years, rev, LAG(rev,1) OVER() AS prev_month_rev
	FROM monthly_sales)

SELECT *, ROUND((rev - prev_month_rev) / prev_month_rev *100,2) AS percentage_difference
FROM prev_month_sales;
```
> In 2018, sales increased by 29.4% until April, then declined by 12.7% in June. However,
> they then experienced an exponential increase of nearly 130% until November, and fell by 77% in the following month.

- 2019 sales growth analysis
```sql
WITH prev_month_sales AS (
	WITH monthly_sales AS (
		SELECT MONTH(order_date) AS months, YEAR(order_date) AS years, ROUND(SUM(sales)) AS rev
		FROM sales_data
		WHERE YEAR(order_date) = 2019
		GROUP BY 1,2
		ORDER BY 1)

	SELECT months, years, rev, LAG(rev,1) OVER() AS prev_month_rev
	FROM monthly_sales)

SELECT *, ROUND((rev - prev_month_rev) / prev_month_rev *100,2) AS percentage_difference
FROM prev_month_sales;
```
> In 2019, sales growth followed a similar pattern to 2018, with the highest growth occurring in November, at 91.4% from the previous month. It then declined sharply in the following month, at -64.7%.

- 2020 sales growth analysis
```sql
WITH prev_month_sales AS (
	WITH monthly_sales AS (
		SELECT MONTH(order_date) AS months, YEAR(order_date) AS years, ROUND(SUM(sales)) AS rev
		FROM sales_data
		WHERE YEAR(order_date) = 2020
		GROUP BY 1,2
		ORDER BY 1)

	SELECT months, years, rev, LAG(rev,1) OVER() AS prev_month_rev
	FROM monthly_sales)

SELECT *, ROUND((rev - prev_month_rev) / prev_month_rev *100,2) AS percentage_difference
FROM prev_month_sales;
```
> In 2020, sales growth peaked in May, reaching 75% higher than the previous month.
> Due to limited data, sales are only recorded up to May 2020.

- Sales by category in %
```sql
SELECT productline, ROUND(SUM(sales)) AS total_sales, 
ROUND(ROUND(SUM(sales)) *100 / (SELECT ROUND(SUM(sales)) FROM sales_data),2) AS percent_of_total
FROM sales_data
GROUP BY 1
ORDER BY 3 DESC;
```
> Classic cars had the highest sales with a total of $3.8 million, accounting for 39% of the total.

- Sales by Country in %
```sql
SELECT country, ROUND(SUM(sales)) AS total_sales,
ROUND(ROUND(SUM(sales)) *100 / (SELECT ROUND(SUM(sales)) FROM sales_data),2) AS percent_of_total
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC;
```
> The USA is the country with the highest sales of $3.3 million, 34% of the total.


## 4. RFM Analysis
- Create temporary table so i can used it latter
```sql
CREATE TEMPORARY TABLE rfm_table AS
WITH rfm AS ( -- Create Recency, Frequency, Monetary Column
	SELECT DISTINCT CONCAT(contact_first_name, " ",contact_last_name) AS cust_name, 
	MAX(days_since_lastorder) AS recency, COUNT(order_number) AS frequency, 
	ROUND(SUM(sales)) AS total_sales
	FROM sales_data
	GROUP BY 1),

rfm_score AS ( -- Create RFM score
	SELECT *,
	NTILE(5) OVER(ORDER BY recency DESC) AS r_score,
	NTILE(5) OVER(ORDER BY frequency ASC) AS f_score,
	NTILE(5) OVER(ORDER BY total_sales ASC) AS m_score
	FROM rfm)

SELECT *, CONCAT(r_score,f_score,m_score) AS score, -- Segemntation customer based on rfm score
CASE
	WHEN CONCAT(r_score,f_score,m_score) >= 522 THEN "Champion"
    WHEN CONCAT(r_score,f_score,m_score) BETWEEN 344 AND 521 THEN "Loyal"
    WHEN CONCAT(r_score,f_score,m_score) BETWEEN 332 AND 343 THEN "Recent Customer"
	WHEN CONCAT(r_score,f_score,m_score) BETWEEN 256 AND 331 THEN "Need Attention"
	ELSE "At Risk"
    END AS cust_segment
FROM rfm_score;
```

- Customer segmentation. I devided customer into 5 segment, Champion, Loyal, Recent Customer, Need Attention, and At Risk
- Champion
```sql
SELECT *
FROM rfm_table
WHERE cust_segment = "Champion"
ORDER BY score DESC;
```

- Loyal
```sql
SELECT *
FROM rfm_table
WHERE cust_segment = "Loyal"
ORDER BY score DESC;
```

- Recent Customer
```sql
SELECT *
FROM rfm_table
WHERE cust_segment = "Recent Customer"
ORDER BY score DESC;
```

- Need Attention
```sql
SELECT *
FROM rfm_table
WHERE cust_segment = "Need Attention"
ORDER BY score DESC;
```

- At Risk
```sql
SELECT *
FROM rfm_table
WHERE cust_segment = "At Risk"
ORDER BY score DESC;
```

## Data Download
- CSV file -> [Auto Sales data.csv](https://github.com/user-attachments/files/22653558/Auto.Sales.data.csv)
- SQL create DB -> [create_db.sql](https://github.com/user-attachments/files/22653566/create_db.sql)
- SQL Exploratory and Analysis -> [EDA.sql](https://github.com/user-attachments/files/22653570/EDA.sql)


> [!NOTE]
> This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You.
