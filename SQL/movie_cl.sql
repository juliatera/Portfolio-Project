-- Data Cleaning Process
-- 1. Create new table base on movie table
CREATE TABLE movie_cl
LIKE movie;

-- 2. Insert all movie data to new table movie_cl (*cl for cleaned)
INSERT movie_cl
SELECT * 
FROM movie;

-- 3. View new table movie_cl
SELECT * FROM movie_cl;

-- 4. Standarization AND Normalization Data Type
-- Change release_date data type (text to date)
ALTER TABLE movie_cl
MODIFY COLUMN release_date DATE;

-- Remove '$' sign in budget and revenue column
UPDATE movie_cl
SET budget = REPLACE(budget, '$','')
WHERE budget  LIKE '$%';

UPDATE movie_cl
SET revenue = REPLACE(revenue, '$','')
WHERE revenue  LIKE '$%';

-- Remove white space in budget and revenue column
UPDATE movie_cl
SET budget = TRIM(budget);

UPDATE movie_cl
SET revenue = TRIM(revenue);

-- Remove Decimals in budget and revenue column
UPDATE movie_cl
SET budget = SUBSTR(budget,1, LENGTH(budget) -3),
revenue = SUBSTR(revenue,1, LENGTH(revenue) -3);

-- Remove coma in budget and revenue column
UPDATE movie_cl
SET budget = REPLACE(budget, ',', ''),
revenue = REPLACE(revenue, ',', '');

-- Change budget and revenue column data type to INT
ALTER TABLE movie_cl
MODIFY COLUMN budget INT;
ALTER TABLE movie_cl
MODIFY COLUMN revenue INT;

-- Check duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
movie_title, release_date, wikipedia_url, genre, director_1, director_2, cast_1, cast_2,
cast_3, cast_4, cast_5, budget, revenue) AS row_num
FROM movie_cl
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;



