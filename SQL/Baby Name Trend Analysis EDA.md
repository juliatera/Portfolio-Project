# Baby Name Trend Analysis EDA

This is a data analysis for Baby Name Trend in USA from 1980 to 2009. I took this data from `Mavin Analtics`. There are 2 tables in this data set, regions and names.
There are more than 50 records in regions table and more than 2 Millions records in names table.
You can download the data [here](https://app.mavenanalytics.io/guided-projects/f71c0a2b-05f4-43fe-a80c-8f3f86964ccc)

## Tools
I used SQL from Google BigQuery for exploritary data and since i cannot save the file because i use it for free, so i copy and paste it in notepad 😅.

## There are 3 main objective :
1. Track changes in name popularity [go here](#first-objective--track-changes-in-name-popularity)
   - Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years
   - Find the names with the biggest jumps in popularity from the first year of the data set to the last year
2. Compare popularity across decades [go here](##second-objective--compare-popularity-across-decades)
   - For each year, return the 3 most popular girl names and 3 most popular boy names
   - For each decade, return the 3 most popular girl names and 3 most popular boy names
3. Find the number of babies born in each region, and also return the top 3 girl names and top 3 boy names within each region [go here](#third-objective--compare-popularity-across-regions)
   - Return the number of babies born in each of the six regions
   - Return the 3 most popular girl names and 3 most popular boy names within each region
4. Find the most popular androgynous names, the shortest and longest names, and the state with the highest percent of babies named "Chris" [go here](#fourth-objective--explore-unique-names-in-the-dataset)
   - Find the 10 most popular androgynous names (names given to both females and males)
   - Find the length of the shortest and longest names, and identify the most popular short names and long names
   - Find the state with the highest percent of babies named "Chris"
#
### First objective : Track changes in name popularity
1. Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years

```sql
SELECT 
  name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
WHERE gender ='F'
GROUP BY name
ORDER BY num DESC
LIMIT 1; -- most popular girl name is Jessica
```

```sql
SELECT 
  name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
WHERE gender ='M'
GROUP BY name
ORDER BY num DESC
LIMIT 1; -- most popular boy name is Michael
```

```sql
--how Jessica's name changed in popularity rankings over the years
SELECT *
FROM
  (WITH girl_name AS (
SELECT 
  year, name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
WHERE gender ='F'
GROUP BY year, name)

SELECT 
  year, name, ROW_NUMBER() OVER(PARTITION BY year ORDER BY num DESC) AS popularity
FROM 
  girl_name) AS popularity_name
WHERE name = 'Jessica'
ORDER BY year; -- The name Jessica was little used from 1980 - 1997, but experienced a surge from 1998 - 2009
```

```sql
--how Michael's name changed in popularity rankings over the years
SELECT *
FROM
  (WITH boy_name AS (
SELECT 
  year, name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
WHERE gender ='M'
GROUP BY year, name)

SELECT 
  year, name, ROW_NUMBER() OVER(PARTITION BY year ORDER BY num DESC) AS popularity
FROM 
  boy_name) AS popularity_name
WHERE name = 'Michael'
ORDER BY year; -- Michael's name doesn't seem to be popular over the years
```

2. Find the names with the biggest jumps in popularity from the first year of the data set to the last year
```sql
-- Create popularity CTE table in 1980
WITH name_1980 AS (
WITH all_name AS (
SELECT 
  year, name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY year, name)

SELECT 
  year, name, ROW_NUMBER() OVER(PARTITION BY year ORDER BY num DESC) AS popularity
FROM 
  all_name
WHERE year = 1980
),

--Create popularity CTE table in 2009
name_2009 AS (

WITH all_name AS (
SELECT 
  year, name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY year, name)

SELECT 
  year, name, ROW_NUMBER() OVER(PARTITION BY year ORDER BY num DESC) AS popularity
FROM 
  all_name
WHERE year = 2009
)

-- Find the names with the biggest jumps over the years using INNER JOIN and find the difference in popularity.
SELECT *, t2.popularity - t1.popularity AS diff
FROM name_1980 t1 JOIN name_2009 t2
ON t1.name = t2.name
ORDER BY diff DESC -- Kerri saw the biggest increase in name popularity over the years, followed by Jo and Timmy.
```

### Second objective : Compare popularity across decades
1. For each year, return the 3 most popular girl names and 3 most popular boy names
```sql
-- Find total birth name
SELECT 
  year, gender, name, SUM(births) AS num
FROM 
  `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY year, gender, name;

-- Rank popularity based on year and gender using CTE
WITH all_name AS(
SELECT year, gender, name, SUM(births) AS num
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY year, gender, name)
SELECT year, gender, name, num, 
       ROW_NUMBER() OVER(PARTITION BY year, gender ORDER BY num DESC) AS popularity
FROM all_name
ORDER BY year;
```

```sql
-- return the 3 most popular girl names and 3 most popular boy names for each year using SUBQUERY
-- and WHERE CLAUSE condition

SELECT * FROM
(WITH all_name AS(
SELECT year, gender, name, SUM(births) AS num
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY year, gender, name)
SELECT year, gender, name, num, 
       ROW_NUMBER() OVER(PARTITION BY year, gender ORDER BY num DESC) AS popularity
FROM all_name
ORDER BY year) AS top_three
WHERE popularity < 4; -- Almost every year Jennifer, Jessica and Amanda are the most popular girls' names, while Michael, Christopher and Matthew are the most popular boys' names.
```

2. For each decade, return the 3 most popular girl names and 3 most popular boy names
```sql
-- The query for this task quite similar from above. I just copy paste down here and modify the 'year' field with CASE statement.
SELECT * FROM
(WITH name_by_decades AS(
SELECT (CASE WHEN year BETWEEN 1980 AND 1989 THEN 'Eighties'
             WHEN year BETWEEN 1990 AND 1999 THEN 'Nineties'
             WHEN year BETWEEN 2000 AND 2009 THEN 'Two_thousands'
             ELSE 'None'END) AS decade,
  gender, name, SUM(births) AS num
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY decade, gender, name)
SELECT 
  decade, gender, name, num, 
  ROW_NUMBER() OVER(PARTITION BY decade, gender ORDER BY num DESC) AS popularity
FROM 
  name_by_decades) AS top_three
WHERE popularity < 4 
ORDER BY decade; -- From eighties to two thousands most popular girls' names changes quite a lot compared to boys' names that had less significan changes
```

### Third objective : Compare popularity across Regions
1. Return the number of babies born in each of the six regions
```sql
-- Clean regions table by exclude 'State' in state field and 'Region' in region field
SELECT * 
FROM `inner-nuance-463607-k8.usa_baby_names.regions`
WHERE state != 'State' AND region != 'Region';
```

```sql
-- Use CTE to join clean_regions table with names table
WITH clean_regions AS (
SELECT * 
FROM `inner-nuance-463607-k8.usa_baby_names.regions`
WHERE state != 'State' AND region != 'Region')

-- return number of babies born for each regions
SELECT region, SUM(births) AS num FROM `inner-nuance-463607-k8.usa_baby_names.names` n
LEFT JOIN clean_regions cr
ON n.state = cr.state
GROUP BY region;
```

2. Return the 3 most popular girl names and 3 most popular boy names within each region
```sql
SELECT * FROM (                    -- 3. use subquery to return 3 most popular girl and boy names with WHERE CLAUSE statement
WITH num_by_region AS (            -- 2. use clean regions CTE within num_by_region CTE and rank total babies names based on region and gender as popularity
WITH clean_regions AS (            -- 1. create clean regions CTE and then join with names table to return total babies names with SUM agg
SELECT * 
FROM `inner-nuance-463607-k8.usa_baby_names.regions`
WHERE state != 'State' AND region != 'Region')

SELECT region, name, gender, SUM(births) AS num
FROM `inner-nuance-463607-k8.usa_baby_names.names` n
LEFT JOIN clean_regions cr
ON n.state = cr.state
GROUP BY region, name, gender)

SELECT region, name, gender, num, 
ROW_NUMBER() OVER(PARTITION BY region, gender ORDER BY num DESC) AS popularity
FROM num_by_region) AS top_three
WHERE popularity < 4
ORDER BY region -- For the girl names like Jessica, Ashley, and Jennifer are the most popular almost in every region
                -- For the boys names like Michael, Matthew, and Christopher are the most popular almost in every region
```

### Fourth objective : Explore unique names in the dataset
1. Find the 10 most popular androgynous names (names given to both females and males)
```sql
SELECT name, COUNT(DISTINCT gender) AS num_gender, SUM(births) total
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY name
HAVING num_gender =2
ORDER BY total DESC
LIMIT 10; -- there are some boy names like Michael, Christopher, Matthew given to girl, while some girl names like Jessica and Ashley given to boy.
```

2. Find the length of the shortest and longest names, and identify the most popular short names and long names
```sql
-- Return the shortest and longest names
SELECT name, LENGTH(name) AS name_length
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY name
ORDER BY name_length; -- 2

SELECT name, LENGTH(name) AS name_length
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY name
ORDER BY name_length DESC; -- 15
```

```sql
-- identify the most popular short names and long names
SELECT name, SUM(births) AS num
FROM `inner-nuance-463607-k8.usa_baby_names.names`
WHERE LENGTH(name) IN (2,15)
GROUP BY name
ORDER BY num DESC; -- Ty is the most popular short name while Franciscojavier is the most popular long name
```

3. Find the state with the highest percent of babies named "Chris"
```sql
-- First i create variables of total babies name Chris and the total of all babies
-- Then i join the 2 variables of total babies name Chris an total of all babies and GROUP them by state
-- Finally i devide total name Chris with total of all babies and multiply it by 100 to find the percent of Chris name 

SELECT state, total_chris/total * 100 AS percent_chris
FROM (
WITH count_chris AS (
SELECT state, SUM(births) AS total_chris
FROM `inner-nuance-463607-k8.usa_baby_names.names`
WHERE name = 'Chris'
GROUP BY state),

count_all AS (
SELECT state, SUM(births) AS total
FROM `inner-nuance-463607-k8.usa_baby_names.names`
GROUP BY state)

SELECT cc.state, cc.total_chris, ca.total FROM count_chris cc JOIN count_all ca
ON cc.state = ca.state) AS count_chris_all
ORDER BY percent_chris DESC -- Out of all the babies that were born in that state, > 0.03 % babies were named Chris, while
                            -- in West Virginia less than 0.01 % babies were named Chris.
```
