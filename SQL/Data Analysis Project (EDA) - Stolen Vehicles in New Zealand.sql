## CAUTION !! 
-- This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

## Stolen vehicle data from the New Zealand police department's vehicle of interest database containing 5 months of data. 
## Each record represents a single stolen vehicle, with data on vehicle type, make, year, color, date stolen and region stolen.
## This data set has 3 tables including a location table, a vehicle table, and stolen vehicles.
## This data set is also taken from Maven Analysis. Data set download -> (https://app.mavenanalytics.io/datasets)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

## There are 4 main objectives in this analysis :
## 1. What day of the week are vehicles most often and least often stolen?
## 2. What types of vehicles are most often and least often stolen? Does this vary by region?
## 3. What is the average age of the vehicles that are stolen? Does this vary based on the vehicle type?
## 4. Which regions have the most and least number of stolen vehicles? What are the characteristics of the regions?

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

## Start of analysis !
-- View and understanding the stolen vehicles data
SELECT * FROM stolen_vehicles;

-- How many vehicles were stolen?
SELECT COUNT(vehicle_id)
FROM stolen_vehicles; -- There are 4553 vehicles stolen

-- What is the time period for vehicle theft?
SELECT MIN(date_stolen) AS min_date, MAX(date_stolen) AS max_date
FROM stolen_vehicles; -- The time period begins at October 7th, 2021 until April 6th, 2022

-- How much time duration is in this data? 
	-- (I used Subquery to find min & max date, and then find the month difference using TIMESTAMPDIFF)
SELECT TIMESTAMPDIFF(MONTH,min_date, max_date) AS month_diff FROM
	(SELECT MIN(date_stolen) AS min_date, MAX(date_stolen) AS max_date
	FROM stolen_vehicles) AS date_diff; -- This data occurred over a period of 5 months

## Analysis of 4 main objectives
## 1. What day of the week are vehicles most often and least often stolen?
	-- (I used Subquery to convert the date to day)
SELECT dow, COUNT(*) AS num_stolen FROM 
	(SELECT DAYNAME(date_stolen) AS dow
	FROM stolen_vehicles) AS day_name
GROUP BY dow
ORDER BY num_stolen DESC; -- Vehicle theft often occurs on Mondays and rarely occurs on Saturdays

## 2. What types of vehicles are most often and least often stolen? Does this vary by region?
SELECT vehicle_type, COUNT(vehicle_type) AS num_stolen
FROM stolen_vehicles 
GROUP BY vehicle_type
ORDER BY num_stolen DESC; -- The type of vehicle that is often stolen is the Stationwagon, while the one that is rarely stolen is Articulated Truck

-- Does this vary by region?
	-- (I used LEFT JOIN to join 'stolen_vehicles' table and 'locations table' to return 'region', 'vehicle_type', and total vehicle stolen by region)
SELECT region, vehicle_type, COUNT(vehicle_type) AS num_stolen
FROM stolen_vehicles sl LEFT JOIN locations l 
	ON sl.location_id = l.location_id
GROUP BY region, vehicle_type
ORDER BY region, num_stolen DESC; -- The types of vehicles stolen also vary by region.

## 3. What is the average age of the vehicles that are stolen? Does this vary based on the vehicle type?
	-- ( I used 'dates' CTE to return the age of stole vehicles, and then using AVG agg to find the average of age vehicles)
SELECT AVG(diff) FROM
	(WITH dates AS (
		SELECT model_year AS my, YEAR(date_stolen) AS year_date
		FROM stolen_vehicles)
	SELECT my, year_date, year_date - my AS diff
	FROM dates) AS diff_year; -- the average age of stolen vehicles is around 16 years

-- Does this vary based on the vehicle type?
	-- (The query for this question basicaly the same from above. I just copy and paste it and then used 'dates' CTE within the Subquery to return the average age of vehicles based on theri type)
SELECT vehicle_type, AVG(diff) AS avg_age FROM
	(WITH dates AS (
		SELECT vehicle_type, model_year AS my, YEAR(date_stolen) AS year_date
		FROM stolen_vehicles)
	SELECT vehicle_type, my, year_date, year_date - my AS diff
	FROM dates) AS diff_year
GROUP BY vehicle_type
ORDER BY avg_age; -- The age of stolen vehicles varies greatly, ranging from 4 years to 64 years depending on the type

## 4. Which regions have the most and least number of stolen vehicles? What are the characteristics of the regions?
	-- (I used LEFT JOIN to join 'stolen_vehicles' table and 'location' table to return 'region' and total vehicles stolen)
SELECT region, COUNT(vehicle_id) AS num_stolen
FROM stolen_vehicles sv LEFT JOIN locations l
	ON sv.location_id = l.location_id
GROUP BY region
ORDER BY num_stolen; -- Auckland is the region with the highest number of vehicle thefts, while Southland has the lowest rate.

-- What are the characteristics of the regions?
	-- (I used LEFT JOIN to join 'stolen_vehicles' table and 'location' table to return 'region', 'population', 'density' and total vehicles stolen
    -- and then order by 'population' and 'num_stolen' DESC to find any correlation )
SELECT region, population, density, COUNT(vehicle_id) AS num_stolen
FROM stolen_vehicles sv LEFT JOIN locations l
	ON sv.location_id = l.location_id
GROUP BY region, population, density
ORDER BY population DESC, num_stolen DESC; -- The area with the most vehicle thefts is Auckland, which has the highest population and population density in New Zealand.

## Additional Analysis 1 : Compare 2 region based on the lowest population and the highest number of stolen vehicles
	-- (I used LEFT JOIN to join 'stolen_vehicles' table and 'location' table, then using WHERE CLAUSE to return the lowest population and the highest number of stolen vehicles
	-- based on previous query)
SELECT region, population, density, COUNT(vehicle_id) AS num_stolen
FROM stolen_vehicles sv LEFT JOIN locations l
	ON sv.location_id = l.location_id
WHERE region IN ('Southland', 'Gisborne')
GROUP BY region, population, density; 
-- Southland has the lowest rate of vehicle theft. Compared to Gisborne, which has the smallest population, the number of thefts in Gisborne is higher than in Southland
-- This may be due to Gisborne's higher population density than Southland. 

## Additional Analysis 2 : Compare the number of stolen vehicles based on the previous month. and what percentage based on the difference
	-- (I used 'total_stolen' CTE to find total vehicle stolen by months)
WITH total_stolen AS (
	SELECT months, years, SUM(num_stolen) AS total
	FROM (
		SELECT MONTH(date_stolen) AS months, YEAR(date_stolen) AS years, COUNT(vehicle_id) AS num_stolen
		FROM stolen_vehicles
		GROUP BY date_stolen) AS sub
	GROUP BY months, years
	ORDER BY years, months),
	-- (I used 'total_mom' CTE to find previous total vehicle stolen by months)
total_mom AS (
	SELECt months, years, total, LAG(total, 1) OVER (ORDER BY years) AS prev_total
    FROM total_stolen)
	-- (I created claculated field to find percent differences by previous month)
SELECT *, ROUND(((total-prev_total)/prev_total),2)*100 AS percent_diff FROM total_mom; 
-- During March, vehicle thefts were recorded at 1,053 vehicles, a 38 percent increase from the 763 vehicles recorded the previous month.
-- then decreased in the following month by almost 70 percent

## Additional Analysis 3 : Which area had the most vehicles stolen in the above period?
	-- (I used 'cte' CTE to join 'stolen_vehicles' table and 'locations' table. Then i calculated total vehicles stolen with WHERE CLAUSE to find specific time based on previous query)
WITH cte AS (
	SELECT date_stolen, region, COUNT(vehicle_id) AS num
	FROM stolen_vehicles sv LEFT JOIN locations l
		ON sv.location_id = l.location_id
	GROUP BY date_stolen, region)
SELECT region, SUM(num) AS total
FROM cte
WHERE date_stolen LIKE '2022-03%'
GROUP BY region
ORDER BY total DESC; -- During this period Aucklanders experienced the most thefts with a total of 425 vehicles lost.

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

##  Analysis Conclusion !

## New Zealand Vehicle Theft Analysis (October 2021 - April 2022)
-- This analysis of vehicle theft data from the New Zealand Police database, covering a five-month period from October 7th, 2021, to April 6th, 2022, reveals several key trends:

-- 1. Total Thefts & Timeline: A total of 4,553 vehicles were reported stolen within this five-month timeframe.
-- 2. Temporal Patterns: Vehicle thefts are most frequent on Mondays and least common on Saturdays.
-- 3. Vehicle Types: Stationwagons are the most frequently stolen vehicle type, whereas Articulated Trucks are rarely targeted. The types of vehicles stolen also show regional variations.
-- 4. Vehicle Age: Stolen vehicles have an average age of 16 years, with ages broadly ranging from 4 to 64 years depending on the specific vehicle type.
-- 5. Geographical Distribution: Auckland, New Zealand's most populous and densely populated region, records the highest number of vehicle thefts (425 thefts). Conversely, Southland has the lowest theft rate.
		-- Notably, despite having a smaller population than Southland, Gisborne experiences a higher number of thefts, potentially due to its higher population density.
-- 6. Monthly Trends: March saw a significant spike in thefts, with 1,053 vehicles reported stolen—a 38% increase from February's 763 thefts. However, this trend reversed sharply in April, with thefts decreasing by almost 70%.

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

## Dashboard 
https://public.tableau.com/views/NewZealandVehicleStolen/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
